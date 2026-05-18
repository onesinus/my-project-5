---
name: pr-preparation
description: Prepare a pull request for review with all checks passing. Use when changes are ready to be committed or a PR needs to be opened.
---

## Workflow

1. **Self-review diff** — Check for debug code, TODOs, secrets, missing validation
2. **Run all checks** — `bash scripts/lint.sh && bash scripts/type-check.sh && bash scripts/test.sh && bash scripts/guardrails-check.sh`
3. **Write PR description** — What / Why / Testing sections
4. **Label and assign** — Add `feat|fix|chore` + `ai-assisted` label
5. **Verify PR size** — Keep under 400 lines; split if larger

Full details: `docs/agents/skills/pr-preparation.md`
