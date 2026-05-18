# ADR-0001: Adopt Flow-First SDLC framework

We adopted a lightweight SDLC framework to eliminate context switching across squads and speed up development. The framework provides a standardised cookiecutter scaffold, PR flow automation, and lightweight spec/ADR templates — with explicit permission to skip process when a change is trivial.

**Status:** accepted

## Context

The organisation had 11–30 developers across multiple squads, building a polyglot platform. Each squad set up repos differently (different CI, different hooks, different PR conventions). Context switching cost was high when people moved between squads. There was no shared definition of "done" or standardised workflow, leading to inconsistent quality and slow cycle times.

## Decision

Adopt the Flow-First SDLC framework with four implementation phases (ordered by ROI):

1. **Unified cookiecutter scaffold** — one project template for every new repo
2. **Spec + ADR workflow** — lightweight decision documentation
3. **PR flow automation** — size limits, review SLAs, merge checks
4. **DORA metrics + retro loop** — data-driven continuous improvement

All phases are optional for trivial changes. The framework enforces consistency when it matters and gets out of the way when it doesn't.

**Key constraints:**
- Specs are 1-page max. An ADR can be 1–3 sentences.
- PRs must be < 400 lines. Review SLA is 4 working hours.
- Conventional Commits are enforced via commitlint + pre-commit hooks.
- The framework is polyglot-friendly: the scaffold includes a universal .gitignore and CI template that works across TypeScript, Python, Go, Java, and Rust.

## Consequences

**Positive:**
- New projects start with identical structure, CI, and hooks — zero setup debates
- Spec/ADR culture prevents building the wrong thing without adding bureaucracy
- PR automation reduces cycle time and frees reviewers from mechanical checks
- Teams can skip process when appropriate, avoiding resentment

**Negative:**
- Existing repos need manual migration (covered by SETUP.md)
- Polyglot auto-detection in scripts handles language-specific setup — see `scripts/setup-ci.sh`, `scripts/lint.sh`, `scripts/test.sh`, `scripts/build.sh`. A post-generation hook deletes irrelevant language config files so each project gets only what it needs.
- Requires buy-in from all squads; a single squad ignoring the conventions undermines the benefit

## Considered options

| Option | Why rejected |
|---|---|
| Do nothing (keep current setup) | Context switching cost would persist; quality would remain inconsistent |
| Buy a commercial ALM platform | Lock-in risk; doesn't solve the cultural/consistency problem; expensive |
| Write a detailed process manual | Manuals get ignored; automation beats documentation |
| Full Agile/Scrum transformation | Too heavy for the stated goal of speed; the team is already small enough to use lightweight processes |
