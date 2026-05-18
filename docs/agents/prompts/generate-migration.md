# Prompt: Generate a database migration

## When to use

You need to alter the database schema — add/remove columns, create tables, add indexes.

## Template

```
Context:
- Database: [PostgreSQL / MySQL / SQLite / MongoDB]
- Migration tool: [e.g. Prisma, Alembic, Flyway, raw SQL]
- Current schema (relevant tables): [path to schema file or relevant model files]
- Change required: [what needs to change and why]

Task:
Generate a migration script that:

1. Is reversible (has both "up" and "down" / "rollback" steps)
2. Handles existing data:
   - New NOT NULL columns: provide a default or backfill step
   - Column removal: ensure no code references it anymore
   - Rename: do NOT drop and recreate — use ALTER TABLE RENAME
3. Includes a dry-run mode or verification query

Constraints:
- Never write DROP TABLE, DROP DATABASE, TRUNCATE
- Never remove a column without checking for dependent code
- Add indexes for new foreign keys and filtered queries
- Test the migration against a copy of production data before applying

Output format:
Migration file(s) with up/down steps.
Include a verification section that confirms the migration worked.

Guardrail warning:
This migration MUST be reviewed by a team lead before running on any shared database.
```

## Example

```
Context:
- Database: PostgreSQL 16
- Migration tool: Prisma
- Current schema: prisma/schema.prisma
- Change required: Add a `discount_code` column to the `orders` table (nullable VARCHAR(50)) and an index on it.

Task: Generate a migration script...
```
