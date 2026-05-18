# ADR-0002: Scaffold update mechanism for generated projects

Generated projects receive the scaffold's full standard structure at creation time, but changes to the scaffold (CI workflows, guardrails scripts, pre-commit config, agent docs) do not automatically propagate. We need a lightweight way for generated projects to pull in upstream scaffold updates without disrupting project-specific modifications.

**Status:** accepted

## Context

The Flow-First cookiecutter scaffold generates a static copy of all standard files (`.github/workflows/*`, `scripts/*`, `docs/agents/*`, `.pre-commit-config.yaml`, etc.). Over time, the scaffold adds better CI checks, improved guardrails, updated agent prompts, and bug fixes. Generated projects are left behind with no mechanism to see what changed or pull in updates.

Two categories of project exist:

1. **Framework-made projects** — generated via cookiecutter, known file structure
2. **Non-framework projects** — pre-existing codebases that may want to adopt individual components

Only Case 1 is addressed in this ADR. Case 2 is deferred.

## Decision

Adopt a **version + manifest + diff script** approach:

1. **`VERSION` file** at the scaffold root — tracks the scaffold's own version (`0.2.0`)
2. **`MANIFEST.yml`** at the scaffold root — lists every standard file with metadata (path, rendered flag, layer, description)
3. **Generation-time metadata** — `post_gen_project.py` saves scaffold version, source URL, and project variables into the generated project (`.scaffold-version`, `.scaffold-source`, `.scaffold-project-vars.json`) plus a filtered `MANIFEST.yml`
4. **`scripts/update-scaffold.sh`** — generated in every project. Compares each manifest file against the latest scaffold version and reports changes. With `--apply`, overwrites files that have no local modifications.

### Update flow

```
Generated project                      Latest scaffold
┌─────────────────┐                    ┌─────────────────┐
│ MANIFEST.yml     │  ◄── fetch ───    │ MANIFEST.yml     │
│ .scaffold-version │                   │ VERSION          │
└─────────────────┘                    └─────────────────┘
         │                                     │
         └────────── diff per file ────────────┘
                           │
              ┌────────────┼────────────┐
              ▼            ▼            ▼
         No diff     Project clean   Local edits
         (skip)     → auto-update   → warn + save diff
```

### What gets tracked

All `always`-layer files from the manifest: CI/CD workflows, scripts, docs templates, pre-commit config, editor config, GitHub issue templates, agent standards. Rendered files (with `{{ cookiecutter.* }}` placeholders) are flagged for manual review. Layer-specific files (framework scaffolds from `_layers/`) are not yet tracked but the manifest schema supports them.

## Consequences

**Positive:**
- Generated projects can see what changed in the scaffold and pull in updates
- Safe for locally-modified files — the script detects conflicts and skips them
- Zero external dependencies — pure bash + Python (stdlib)
- The version file is a single source of truth for scaffold releases
- The manifest doubles as documentation of what the scaffold provides

**Negative:**
- Only tracks files from the `always` layer initially; framework-specific files (FastAPI build scripts, NestJS configs, etc.) are not yet covered
- No automatic merge for rendered files (those with project-specific substitutions) — they always require manual review
- Requires the project to have network access to the scaffold repository
- The `--apply` mode gives a semver-like version comparison, but the real diff is file-by-file; there is no dependency resolution

## Considered options

| Option | Why rejected |
|---|---|
| Git subtree | Requires subtree workflow discipline; hard to retrofit on existing repos; conflicts with the project's own git history |
| Standalone CLI tool | Most robust but requires external tooling; the scaffold aims to be zero-dependency |
| Templated-bleed markers | Comments in every file to identify scaffold origin — fragile and noisy |
| Manual check | Already the status quo; leads to abandoned projects running stale CI/g4rdrails |
