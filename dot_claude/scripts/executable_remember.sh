#!/usr/bin/env bash
# mnemory remember hook for Claude Code (Stop)
#
# Adapted from integrations/claude-code to match the current Claude Code hook
# I/O schema: Stop provides `.transcript_path` (a JSONL file) and `.session_id`
# rather than an inline `.transcript` array / `.stopReason`. We read the
# transcript file and extract the most recent genuine human prompt (and,
# optionally, the most recent assistant reply), then POST /api/remember.
#
# Config is sourced from ~/.claude/scripts/mnemory.env (chmod 600):
#   MNEMORY_URL MNEMORY_API_KEY MNEMORY_AGENT_ID MNEMORY_USER_ID MNEMORY_INCLUDE_ASSISTANT

set -euo pipefail

if [ -f "$HOME/.claude/scripts/mnemory.env" ]; then
    # shellcheck disable=SC1091
    . "$HOME/.claude/scripts/mnemory.env"
fi

MNEMORY_URL="${MNEMORY_URL:-http://localhost:8050}"
MNEMORY_API_KEY="${MNEMORY_API_KEY:-}"
MNEMORY_AGENT_ID="${MNEMORY_AGENT_ID:-claude-code}"
MNEMORY_USER_ID="${MNEMORY_USER_ID:-}"
MNEMORY_INCLUDE_ASSISTANT="${MNEMORY_INCLUDE_ASSISTANT:-false}"

INPUT=$(cat)

# Avoid re-entrancy when a prior Stop hook is still active.
STOP_HOOK_ACTIVE=$(echo "$INPUT" | jq -r '.stop_hook_active // false' 2>/dev/null || echo "false")
if [ "$STOP_HOOK_ACTIVE" = "true" ]; then
    echo '{}'
    exit 0
fi

TRANSCRIPT_PATH=$(echo "$INPUT" | jq -r '.transcript_path // empty' 2>/dev/null || true)
SESSION_ID_FROM_INPUT=$(echo "$INPUT" | jq -r '.session_id // .sessionId // empty' 2>/dev/null || true)

if [ -z "$TRANSCRIPT_PATH" ] || [ ! -f "$TRANSCRIPT_PATH" ]; then
    echo '{}'
    exit 0
fi

# Extract the last non-empty message text for a given role from the transcript
# JSONL. String content is used directly; array content keeps only `text`
# blocks (so tool_result user entries and thinking/tool_use blocks are skipped).
extract_last() {
    jq -rs --arg role "$1" '
        [ .[]
          | select(.type == $role)
          | select((.isMeta // false) | not)
          | select((.isSidechain // false) | not)
          | .message.content
          | if type == "string" then .
            elif type == "array" then ([ .[] | select(.type == "text") | .text ] | join("\n"))
            else "" end
        ]
        | map(select(. != null and . != ""))
        | last // ""
    ' "$TRANSCRIPT_PATH" 2>/dev/null || echo ""
}

USER_MSG=$(extract_last user)
if [ -z "$USER_MSG" ]; then
    echo '{}'
    exit 0
fi

if [ "$MNEMORY_INCLUDE_ASSISTANT" = "true" ]; then
    ASSISTANT_MSG=$(extract_last assistant)
    MESSAGES=$(jq -n --arg u "$USER_MSG" --arg a "$ASSISTANT_MSG" \
        '[{role: "user", content: $u}] + (if $a != "" then [{role: "assistant", content: $a}] else [] end)')
else
    MESSAGES=$(jq -n --arg u "$USER_MSG" '[{role: "user", content: $u}]')
fi

MNEMORY_SESSION_ID=""
SESSION_FILE="/tmp/mnemory_session_${SESSION_ID_FROM_INPUT:-default}"
if [ -f "$SESSION_FILE" ]; then
    MNEMORY_SESSION_ID=$(cat "$SESSION_FILE" 2>/dev/null || true)
fi

HEADERS=(-H "Content-Type: application/json" -H "X-Agent-Id: $MNEMORY_AGENT_ID")
if [ -n "$MNEMORY_API_KEY" ]; then
    HEADERS+=(-H "Authorization: Bearer $MNEMORY_API_KEY")
fi
if [ -n "$MNEMORY_USER_ID" ]; then
    HEADERS+=(-H "X-User-Id: $MNEMORY_USER_ID")
fi

LABELS=$(jq -n --arg src "claude-code" --arg sid "$SESSION_ID_FROM_INPUT" \
    '{source: $src} + (if $sid != "" then {session_id: $sid} else {} end)')

BODY=$(jq -n \
    --argjson messages "$MESSAGES" \
    --arg session_id "$MNEMORY_SESSION_ID" \
    --argjson labels "$LABELS" \
    '{messages: $messages, labels: $labels}
    + (if $session_id != "" then {session_id: $session_id} else {} end)'
)

# Fire-and-forget.
curl -s --max-time 10 \
    -X POST \
    "${HEADERS[@]}" \
    -d "$BODY" \
    "${MNEMORY_URL}/api/remember" >/dev/null 2>&1 &

echo '{}'
