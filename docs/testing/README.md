# Testing

Standardised test conventions across all projects.

## Test pyramid

```
    /\         e2e — slow, few     Coverage: 80%+ of critical paths
   /  \        integration — fewer  Coverage: 60%+ of API/data layers
  /    \
 / unit \      unit — fast, many    Coverage: 90%+ of business logic
/________\
```

| Layer | Speed | Count | External deps | Runs in CI |
|---|---|---|---|---|
| Unit | ms | Many | No | Always |
| Integration | sec | Fewer | Yes (DB, API, etc.) | Always |
| E2E | min | Few | Full system | On merge to main |

## Directory structure

```
tests/
├── unit/           # Fast, isolated tests (no DB, no network)
├── integration/    # Tests with real dependencies
├── e2e/            # Full end-to-end flows
├── fixtures/       # Shared test data (factories, seeds)
└── README.md
```

## Naming conventions

- **Files**:
  - Unit: `<name>.test.<ext>` or `test_<name>.<ext>` or `<name>_test.<ext>` (language convention)
  - Integration: `<name>.int.test.<ext>` or `test_<name>_int.<ext>`
  - E2E: `<name>.e2e.test.<ext>` or `test_<name>_e2e.<ext>`
- **Suites**: Group by module, then feature
- **Cases**: Descriptive sentences describing expected behavior

```
tests/unit/
├── user.test.ts          → TypeScript: `describe('UserService')`
├── test_user.py          → Python: `class TestUserService`
└── user_test.go          → Go: `func TestUserService`
```

## What to test

### Unit tests
- Business logic and calculations
- Input validation and edge cases
- Error paths and exceptions
- Pure functions and utilities

### Integration tests
- API endpoints (request → response)
- Database operations (CRUD, migrations)
- External service integration (with test doubles or real instances)
- Event/message processing

### E2E tests
- Critical user journeys (login, purchase, signup)
- Cross-service flows
- Deployment verification (smoke tests)

## Coverage targets

| Layer | Minimum | Stretch |
|---|---|---|
| Unit | 90% | 95% |
| Integration | 60% | 80% |
| E2E | 20% of critical paths | 50% |

Coverage is measured per layer. CI fails if any layer is below minimum.

## Commands

```bash
# Run all tests
bash scripts/test.sh

# Run specific layer
bash scripts/test.sh --unit
bash scripts/test.sh --integration
bash scripts/test.sh --e2e

# Run with coverage
bash scripts/test.sh --coverage

# Run in watch mode (development)
bash scripts/test.sh --watch

# Run specific test file
bash scripts/test.sh -- tests/unit/user.test.ts
bash scripts/test.sh -- tests/unit/test_user.py
bash scripts/test.sh -- tests/unit/user_test.go
```

## CI integration

The `ci.yml` workflow runs:
- **Unit tests** on every push/PR
- **Integration tests** on every push/PR
- **E2E tests** on merge to main (post-merge)

Coverage reports are generated as artifacts and posted on PRs via `coverage.sh`.
