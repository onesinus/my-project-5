# Tests

```
tests/
├── unit/           Fast, isolated tests (no DB, no network)
├── integration/    Tests with real dependencies
├── e2e/            Full end-to-end flows
├── fixtures/       Shared factories, seeds, mock data
└── README.md       This file
```

## Running tests

```bash
bash scripts/test.sh           # all tests
bash scripts/test.sh --unit    # unit only
bash scripts/test.sh --coverage
bash scripts/test.sh --watch
```

## Adding a test

1. Find the right directory (`tests/unit/`, `tests/integration/`, `tests/e2e/`)
2. Create a test file following your language's naming convention:
   - TypeScript: `<name>.test.ts`
   - Python: `test_<name>.py`
   - Go: `<name>_test.go`
   - Rust: `<name>_test.rs`
   - Java: `<name>Test.java`
3. Run `bash scripts/test.sh --unit` to confirm it passes

## Fixtures

Shared test data lives in `tests/fixtures/`. Use factories or builders to keep tests readable:

```ts
// tests/fixtures/user-factory.ts
export function createUser(overrides = {}) {
  return { name: 'default', email: 'test@example.com', ...overrides }
}
```

```python
# tests/fixtures/user_factory.py
def create_user(**overrides):
    defaults = {"name": "default", "email": "test@example.com"}
    defaults.update(overrides)
    return defaults
```

## Coverage

| Layer | Minimum |
|---|---|
| unit | 90% |
| integration | 60% |

Run `bash scripts/test.sh --coverage` to check.
