# Instructions for Codex - CyberSafe Lebanon

Use `CyberSafe_Lebanon_SRS_Technical_Design.md` as the authoritative implementation baseline.

## Build strategy
1. Create the monorepo exactly as described under "Application modules / monorepo".
2. Use strict TypeScript everywhere.
3. Implement a modular monolith, not microservices, for MVP.
4. Create provider interfaces for OIDC, AI, OCR, URL reputation, object storage, malware scan, notifications, and observability.
5. Provide mock/local adapters so the full development environment runs without paid external services.
6. Generate migrations from `DATABASE_SCHEMA.sql`; do not enable automatic schema synchronization in production.
7. Generate OpenAPI and keep it compatible with `openapi.yaml`.
8. Never put API keys or secrets in mobile code.
9. Never make arbitrary URL requests from the AI model or mobile app.
10. Treat uploaded content as untrusted.
11. Ensure guest mode works without signup.
12. Use Expo SecureStore for token/session secrets on native clients.
13. Implement Arabic RTL from the first UI components, not as a later retrofit.
14. Add unit/integration/E2E tests as each module is built.
15. Add a `docs/adr` entry whenever deviating from the SRS.

## First milestone
Deliver:
- Docker Compose for PostgreSQL + pgvector, Redis, MinIO, ClamAV
- NestJS API/worker skeleton
- Expo Router mobile skeleton
- Next.js admin skeleton
- guest session creation
- onboarding
- Home
- text/URL analysis using deterministic rules + mock AI provider
- analysis result screen
- unit/integration tests
- CI workflow

Do not implement a real external AI provider until the mock pipeline, schemas, security boundaries, and evaluation fixtures are working.

## Mandatory dynamic-first requirement
CyberSafe Lebanon is a dynamic platform. Do **not** hard-code production lessons, FAQs, homepage sections, alerts, reporting routes, scam examples, risk-rule definitions, incident-playbook wording/logic, CyberBuddy suggested prompts, campaigns, or resource lists in the mobile binary.

Implement from the beginning:
- experience manifest API;
- secure client component registry;
- content/config versioning;
- last-known-good client cache;
- ETag/update logic;
- CMS draft/review/approve/publish/rollback workflow;
- dynamic declarative incident playbooks;
- data-driven risk rule sets;
- approved source registry;
- AI content proposal queue;
- human/security approval before AI-generated updates are published;
- freshness/review/expiry metadata on safety-critical content.

Seed content may exist for local development/tests only. Treat mobile/PWA as a presentation/interaction shell backed by dynamic content services.
