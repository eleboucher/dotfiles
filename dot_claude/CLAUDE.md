# CLAUDE.md

Behavioral guidelines to reduce common LLM coding mistakes. Merge with project-specific instructions as needed.

**Tradeoff:** These guidelines bias toward caution over speed. For trivial tasks, use judgment.

## 1. Think Before Coding

**Don't assume. Don't hide confusion. Surface tradeoffs.**

Before implementing:

- State your assumptions explicitly. If uncertain, ask.
- If multiple interpretations exist, present them - don't pick silently.
- If a simpler approach exists, say so. Push back when warranted.
- If something is unclear, stop. Name what's confusing. Ask.

## 2. Simplicity First

**Minimum code that solves the problem. Nothing speculative.**

- No features beyond what was asked.
- No abstractions for single-use code.
- No "flexibility" or "configurability" that wasn't requested.
- No error handling for impossible scenarios.
- If you write 200 lines and it could be 50, rewrite it.

Ask yourself: "Would a senior engineer say this is overcomplicated?" If yes, simplify.

## 3. Surgical Changes

**Touch only what you must. Clean up only your own mess.**

When editing existing code:

- Don't "improve" adjacent code, comments, or formatting.
- Don't refactor things that aren't broken.
- Match existing style, even if you'd do it differently.
- If you notice unrelated dead code, mention it - don't delete it.

When your changes create orphans:

- Remove imports/variables/functions that YOUR changes made unused.
- Don't remove pre-existing dead code unless asked.

The test: Every changed line should trace directly to the user's request.

## 4. Goal-Driven Execution

**Define success criteria. Loop until verified.**

Transform tasks into verifiable goals:

- "Add validation" → "Write tests for invalid inputs, then make them pass"
- "Fix the bug" → "Write a test that reproduces it, then make it pass"
- "Refactor X" → "Ensure tests pass before and after"

For multi-step tasks, state a brief plan:

```
1. [Step] → verify: [check]
2. [Step] → verify: [check]
3. [Step] → verify: [check]
```

Strong success criteria let you loop independently. Weak criteria ("make it work") require constant clarification.

## 5. Verify Current State

**Look it up. Don't pick from memory or from what's installed locally.**

Before pinning a version, quoting an API shape, naming a release asset, or referencing a repo path:

- `gh release view --repo <owner>/<repo>` for the latest tag and asset names.
- `gh api repos/<owner>/<repo>/contents/<path>` for current file contents.
- `gh search code --repo <repo> "<symbol>"` to confirm a symbol still exists.
- Project MCP tools when available (e.g. context7 for library docs, github-mcp for repo state).

Don't pin a tool to whatever happens to be on your machine — check what's current. Don't restate an API field from training memory — verify it. Cheap lookup, real correctness.

## 6. Git Workflow

**Local-only by default. Plain commit messages.**

- Never run `git push` (or `git push --force`, `gh pr merge`, or anything else that updates a remote) without an explicit instruction in the current turn. A prior "commit and push" authorization covers exactly one push and does not carry forward.
- Never add `Co-Authored-By` (or any other co-author trailer) to commit messages unless the user explicitly asks for it in the current turn. Write commits with just the subject and body.
- Safe by default: `git add`, `git commit`, `git status`, `git diff`, `git log`, branch creation.

Never add AI SLOPS
