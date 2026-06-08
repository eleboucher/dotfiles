#!/usr/bin/env bash
# mnemory recall hook for Claude Code (UserPromptSubmit)
#
# Adapted from integrations/claude-code to match the current Claude Code hook
# I/O schema: the prompt arrives as `.prompt` (not `.message`), the session id
# as `.session_id`, and context is injected via `hookSpecificOutput`.
#
# Config is sourced from ~/.claude/scripts/mnemory.env (chmod 600), with these
# variables (env overrides the file):
#   MNEMORY_URL MNEMORY_API_KEY MNEMORY_AGENT_ID MNEMORY_USER_ID MNEMORY_SCORE_THRESHOLD

set -euo pipefail

if [ -f "$HOME/.claude/scripts/mnemory.env" ]; then
    # shellcheck disable=SC1091
    . "$HOME/.claude/scripts/mnemory.env"
fi

MNEMORY_URL="${MNEMORY_URL:-http://localhost:8050}"
MNEMORY_API_KEY="${MNEMORY_API_KEY:-}"
MNEMORY_AGENT_ID="${MNEMORY_AGENT_ID:-claude-code}"
MNEMORY_USER_ID="${MNEMORY_USER_ID:-}"
MNEMORY_SCORE_THRESHOLD="${MNEMORY_SCORE_THRESHOLD:-0.5}"

INPUT=$(cat)

# Current Claude Code: user prompt is `.prompt`; keep `.message` as a fallback.
USER_MESSAGE=$(echo "$INPUT" | jq -r '.prompt // .message // empty' 2>/dev/null || true)
SESSION_ID_FROM_INPUT=$(echo "$INPUT" | jq -r '.session_id // .sessionId // empty' 2>/dev/null || true)
SESSION_FILE="/tmp/mnemory_session_${SESSION_ID_FROM_INPUT:-default}"

MNEMORY_SESSION_ID=""
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

BODY=$(jq -n \
    --arg query "$USER_MESSAGE" \
    --arg session_id "$MNEMORY_SESSION_ID" \
    --argjson score_threshold "$MNEMORY_SCORE_THRESHOLD" \
    '{
        include_instructions: true,
        managed: true,
        score_threshold: $score_threshold
    }
    + (if $query != "" then {query: $query} else {} end)
    + (if $session_id != "" then {session_id: $session_id} else {} end)'
)

RESPONSE=$(curl -s --max-time 25 \
    -X POST \
    "${HEADERS[@]}" \
    -d "$BODY" \
    "${MNEMORY_URL}/api/recall" 2>/dev/null || echo '{}')

NEW_SESSION_ID=$(echo "$RESPONSE" | jq -r '.session_id // empty' 2>/dev/null || true)
if [ -n "$NEW_SESSION_ID" ]; then
    echo "$NEW_SESSION_ID" > "$SESSION_FILE"
fi

CONTEXT_PARTS=""

INSTRUCTIONS=$(echo "$RESPONSE" | jq -r '.instructions // empty' 2>/dev/null || true)
if [ -n "$INSTRUCTIONS" ]; then
    CONTEXT_PARTS="$INSTRUCTIONS"
fi

CORE_MEMORIES=$(echo "$RESPONSE" | jq -r '.core_memories // empty' 2>/dev/null || true)
if [ -n "$CORE_MEMORIES" ]; then
    if [ -n "$CONTEXT_PARTS" ]; then
        CONTEXT_PARTS="$CONTEXT_PARTS

$CORE_MEMORIES"
    else
        CONTEXT_PARTS="$CORE_MEMORIES"
    fi
fi

SEARCH_RESULTS=$(echo "$RESPONSE" | jq -r '
    .search_results // [] |
    map(select(.memory != null and .memory != "")) |
    map("- " + .memory) |
    join("\n")' 2>/dev/null || true)

if [ -n "$SEARCH_RESULTS" ]; then
    RECALLED="## Recalled Memories
$SEARCH_RESULTS"
    if [ -n "$CONTEXT_PARTS" ]; then
        CONTEXT_PARTS="$CONTEXT_PARTS

$RECALLED"
    else
        CONTEXT_PARTS="$RECALLED"
    fi
fi

# Inject via the current hookSpecificOutput form for UserPromptSubmit.
if [ -n "$CONTEXT_PARTS" ]; then
    jq -n --arg ctx "$CONTEXT_PARTS" \
        '{hookSpecificOutput: {hookEventName: "UserPromptSubmit", additionalContext: $ctx}}'
else
    echo '{}'
fi
