# Contributing

## PR flow

```
[Branch] ──→ [Commit] ──→ [Push] ──→ [PR] ──→ [Auto-checks] ──→ [Review] ──→ [Merge]
```

1. **Branch**: `feat/description`, `fix/description`, `chore/description`
2. **Commit**: Conventional Commits (enforced by pre-commit hook)
3. **Push**: Pre-push hook runs lint + tests
4. **PR**: Title follows conventional commits, body has What/Why/Testing
5. **Auto-checks** (run immediately):
   - CI: lint → type-check → test → build
   - PR size < 400 lines
   - Branch name follows convention
   - CHANGELOG entry required for feat/fix
   - Labels must be set
   - Reviewer auto-assigned from CODEOWNERS
6. **Human review** (SLA: 4 working hours):
   - If unreviewed after 4h → bot pings reviewer
   - If unreviewed after 8h → escalates to squad lead
7. **Merge**: Squash merge via merge queue (auto-updates branch, runs final CI)

## Commits

Use [Conventional Commits](https://www.conventionalcommits.org/):

```
feat(auth): add OAuth2 login flow
fix(db): handle connection timeout on startup
refactor(api): extract validation middleware
chore(deps): upgrade lodash to v5
test(auth): add integration tests for login
docs(readme): update setup instructions
```

Types: `feat`, `fix`, `chore`, `docs`, `refactor`, `test`, `style`, `perf`, `ci`, `build`, `revert`

## PR standards

- **Size**: < 400 lines changed (exclude generated files)
- **Title**: `type(scope): description`
- **Description**: Must include What / Why / Testing sections
- **CHANGELOG**: Include entry for feat/fix PRs
- **Labels**: At least one label required
- **Draft**: Use draft PRs for work-in-progress

## Review standards

- **SLA**: First review within 4 working hours
- **Reviewers**: Auto-assigned from CODEOWNERS
- **Focus**: Correctness, security, maintainability
- **Request changes**: Be specific about what to change and why
- **Merge strategy**: Squash merge (keeps main history clean)

## Branch protection (recommended settings)

Configure these in your repository settings:

| Setting | Value |
|---|---|
| Require PR before merging | Yes |
| Require status checks | CI / required-checks, PR checks |
| Require up-to-date branches | Yes |
| Require merge queue | Yes |
| Maximum PRs in queue | 5 |
| Build concurrency | 1 |
| Include PR checks | Yes |
| Dismiss stale approvals | Yes |
| Require approval | 1 reviewer |

## DORA metrics

We track four standard DevOps metrics to measure velocity and stability:

| Metric | Target | How to check |
|---|---|---|
| Deployment Frequency | On-demand | `bash scripts/dora-metrics.sh` |
| Lead Time for Changes | < 1 hour | `bash scripts/dora-metrics.sh` |
| Change Failure Rate | < 5% | `bash scripts/dora-metrics.sh` |
| MTTR | < 1 hour | Tracked via [incident response](./docs/runbooks/incident-response.md) |

A weekly metrics report is auto-generated (see `dora-metrics.yml` workflow). Review trends at monthly squad retro using [retro template](./docs/metrics/retro-template.md).

## Incidents

See [incident response runbook](./docs/runbooks/incident-response.md) for severity levels, process, and post-mortem template.

## Testing

See [testing guide](./docs/testing/README.md) for full conventions.

```bash
bash scripts/test.sh              # all tests
bash scripts/test.sh --unit       # unit only
bash scripts/test.sh --coverage   # with coverage report
bash scripts/coverage.sh --open   # open HTML report
```

| Layer | Location | Runs in CI | Min coverage |
|---|---|---|---|
| Unit | `tests/unit/` | Every PR | 90% |
| Integration | `tests/integration/` | Every PR | 60% |
| E2E | `tests/e2e/` | Merge to main | 20% critical paths |

## Code standards

- Follow the language's idiomatic style
- Write tests for new functionality
- Update docs for public APIs
- No warnings in lint or type-check
- No secrets committed (enforced by pre-commit)
