# CyberSafe Lebanon — AI Development Package Manifest

This package is intended to be handed to Codex or another capable software-engineering AI agent.

## Start here
1. `MASTER_AI_BUILD_PROMPT.md` — master implementation instruction.
2. `CyberSafe_Lebanon_SRS_Technical_Design.md` — full authoritative SRS and architecture.
3. `CODEX_README.md` — implementation conventions.

## Technical contracts
4. `DATABASE_SCHEMA.sql` — PostgreSQL baseline schema.
5. `openapi.yaml` — API baseline.
6. `.env.example` — configuration template only; no real secrets.

## Human-readable reference
7. `CyberSafe_Lebanon_Technical_Specification_v2_Dynamic.pdf` — full technical specification PDF.

## Recommended AI-agent instruction
Provide the full folder/ZIP to the engineering agent and say:

> Read `MASTER_AI_BUILD_PROMPT.md` first, then inspect every supplied project file before making changes. Treat the SRS as authoritative. Begin with Milestone 0 only and do not proceed to the next milestone until the current one builds, tests pass, documentation is updated, and deviations are recorded as ADRs.
