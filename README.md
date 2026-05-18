# my-project-5



## Stack

| Layer | Technology |
|---|---|
| **Web** | None |
| **Backend** | Python + FastAPI |
| **Mobile** | None |
| **Version** | 0.1.0 |

See [AGENTS.md](./AGENTS.md) for detailed stack info and per-framework commands.

## Quick start

```bash
# Bootstrap project
bash scripts/setup.sh

# Start dev server
bash scripts/run.sh

# Run checks
bash scripts/lint.sh
bash scripts/test.sh
```

## Development

```bash
bash scripts/run.sh          # Start dev server
bash scripts/lint.sh         # Check code style
bash scripts/type-check.sh   # Static / type checking
bash scripts/test.sh         # Run tests
bash scripts/coverage.sh     # Coverage report
bash scripts/build.sh        # Build
```

## Committing

This repo uses [Conventional Commits](https://www.conventionalcommits.org/):

```
feat(auth): add OAuth login
fix(api): handle null response in user lookup
chore(deps): upgrade lodash to 4.17.21
```

## PR checklist

Before opening a PR:

- [ ] PR is < 400 lines
- [ ] Title follows conventional commits
- [ ] Description includes What / Why / Testing
- [ ] Tests added or updated
- [ ] Self-reviewed

## Docs

- [Specs](./docs/specs/) — feature specifications
- [ADRs](./docs/adr/) — architecture decisions
- [Runbooks](./docs/runbooks/) — operational procedures
- [AGENTS.md](./AGENTS.md) — AI agent context
