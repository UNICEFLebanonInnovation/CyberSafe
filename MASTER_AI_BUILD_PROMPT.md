# MASTER AI BUILD PROMPT — CYBERSAFE LEBANON

## Role
You are the lead software architect, senior full-stack engineer, mobile engineer, backend engineer, AI/RAG engineer, DevSecOps engineer, QA engineer, accessibility engineer, and security engineer responsible for implementing **CyberSafe Lebanon** from the supplied technical specification.

Your job is to produce a production-grade, secure, maintainable, testable implementation — not a throwaway prototype.

Treat the files supplied with this prompt as authoritative project inputs:

1. `CyberSafe_Lebanon_SRS_Technical_Design.md` — authoritative functional, non-functional, technical, security, privacy, data-flow, dynamic-content and architecture specification.
2. `DATABASE_SCHEMA.sql` — baseline PostgreSQL data model to be implemented via versioned migrations.
3. `openapi.yaml` — baseline API contract to expand and keep synchronized with implementation.
4. `.env.example` — baseline configuration contract; never place real secrets in the repository.
5. `CODEX_README.md` — implementation conventions and sequencing guidance.
6. `CyberSafe_Lebanon_Technical_Specification_v2_Dynamic.pdf` — human-readable technical reference; the Markdown SRS remains the most implementation-friendly source.

If any implementation choice conflicts with the SRS, follow the SRS unless the choice is technically impossible. If you must deviate, create an Architecture Decision Record under `docs/adr/` explaining the reason, alternatives, security/privacy impact, and migration path.

---

# 1. PRODUCT MISSION

Build **CyberSafe Lebanon**, a year-round, multilingual, privacy-preserving digital-safety platform for adolescents and young adults aged approximately 13–24, university/TVET students, educators, youth organizations, parents/caregivers, and youth-facing institutions.

The system must transform cybersecurity awareness from a time-bound campaign into an always-available practical service where users can:

- check a suspicious link, message, screenshot, image, or QR code;
- receive a cautious AI-assisted and deterministic risk assessment;
- ask CyberBuddy for grounded digital-safety guidance;
- launch step-by-step incident recovery playbooks;
- find verified reporting/help routes;
- complete short lessons, quizzes, missions and challenges;
- receive verified cyber alerts;
- use essential emergency material offline;
- access content in Arabic and English at MVP, with French-ready architecture;
- use core safety functions without mandatory registration.

The user promise is:

**Check → Understand → Act → Learn.**

The system must never present itself as an antivirus, endpoint protection product, guaranteed phishing detector, law-enforcement system, surveillance system, or automatic account-recovery service.

---

# 2. NON-NEGOTIABLE ARCHITECTURAL DECISION: DYNAMIC-FIRST

The mobile/PWA client is primarily a secure presentation and interaction shell.

**Do not hard-code production content or operational cyber-safety intelligence into the mobile application.**

The following must be backend/CMS/configuration-driven, versioned, remotely adjustable, reviewable, publishable, expirable, and rollback-capable:

- home-page cards;
- hero content;
- priority alerts;
- featured topics;
- weekly challenges;
- learning resources;
- FAQ content;
- CyberBuddy knowledge sources;
- scam patterns;
- phishing indicators;
- deterministic risk-rule sets;
- incident playbooks and decision trees;
- reporting/help routes;
- campaign content;
- audience targeting rules;
- prompt-template versions;
- source registries;
- content-review dates;
- feature ordering;
- multilingual content variants.

Remote configuration may only reference predefined safe UI components and approved schemas. **Never implement remote arbitrary JavaScript/code execution.**

The publication lifecycle must support:

`DRAFT → AI_PROPOSED → IN_REVIEW → SECURITY/SAFEGUARDING_REVIEW (when applicable) → APPROVED → SCHEDULED/PUBLISHED → EXPIRED/ARCHIVED`

The AI may assist with detection, drafting, translation, summarization, classification, content comparison, threat clustering and proposed updates, but:

**AI proposes; authorized humans approve.**

High-impact safety guidance must not auto-publish from an LLM.

---

# 3. REQUIRED REFERENCE STACK

Use this stack unless an ADR documents a justified deviation.

## Client
- React Native + Expo
- Expo Router
- TypeScript strict mode
- PWA/web support
- TanStack Query for server state
- Zustand for minimal local UI/session state
- React Hook Form + Zod
- Expo SecureStore for sensitive token/session material
- Expo Notifications / FCM / APNs abstraction
- i18n with RTL support from the beginning

## Admin
- Next.js + TypeScript
- Staff SSO/OIDC + MFA
- RBAC and audit logging
- Dynamic CMS and review workflows

## Backend
- NestJS + TypeScript
- REST JSON API
- OpenAPI 3.1
- modular monolith for MVP
- provider adapters/interfaces for external services

## Database and infrastructure
- PostgreSQL 16+
- pgvector
- Prisma for relational ORM/migrations where practical
- raw SQL migrations for pgvector/specialized indexes where needed
- Redis 7+
- BullMQ
- private S3-compatible object storage
- Docker
- GitHub Actions
- OpenTelemetry
- managed secret store in hosted environments

## AI/security processing
- backend-only AI gateway/provider abstraction
- OCR/QR adapter
- URL/domain reputation adapter
- malware-scanning adapter
- deterministic risk-rule engine
- RAG over approved content only

---

# 4. REQUIRED MONOREPO STRUCTURE

Create:

```text
cybersafe-lebanon/
  apps/
    mobile/
    admin/
    api/
    worker/
  packages/
    contracts/
    ui/
    config/
    localization/
    security-rules/
  infrastructure/
    docker/
    terraform-or-bicep/
  docs/
    adr/
    api/
    threat-model/
    runbooks/
  scripts/
  .github/workflows/
```

Also maintain:

- `README.md`
- `ARCHITECTURE.md`
- `THREAT_MODEL.md`
- `PRIVACY_DATA_MAP.md`
- `DATA_RETENTION.md`
- `AI_MODEL_CARD.md`
- `AI_EVALUATION.md`
- `CONTENT_GOVERNANCE.md`
- `SAFEGUARDING_ESCALATION.md`
- `INCIDENT_RESPONSE.md`
- `RUNBOOK.md`
- `BACKUP_RESTORE.md`
- `SECURITY_TEST_PLAN.md`
- generated/maintained `openapi.yaml`

---

# 5. REQUIRED DOMAIN MODULES

Backend modules:

- AuthModule
- SessionModule
- UserModule
- DeviceModule
- AnalysisModule
- UploadModule
- ReputationModule
- OcrModule
- AiGatewayModule
- ChatModule
- KnowledgeModule
- IncidentModule
- ReportingModule
- ContentModule
- ExperienceManifestModule
- ThreatSourceModule
- ThreatIngestionModule
- RiskRuleModule
- ContentProposalModule
- ReviewWorkflowModule
- LearningModule
- ChallengeModule
- AlertModule
- NotificationModule
- AnalyticsModule
- AdminModule
- AuditModule
- HealthModule
- FeatureFlagModule

Keep interfaces between domains explicit. External SDKs live in adapters, not domain logic.

---

# 6. USER MODES AND AUTHENTICATION

## Guest-first is mandatory
A new user must be able to:
- select language;
- read privacy/safety notice;
- create an anonymous guest session;
- reach Home;
- check text/URL content;
- use basic image checking;
- use CyberBuddy;
- access incident playbooks;
- access help/reporting routes;
- browse learning resources;
without creating an account.

## Optional registered account
Registration is offered only for user benefits such as:
- cross-device saved progress;
- badges;
- saved resources;
- notification preferences;
- synchronized learning history.

Use OAuth2/OIDC Authorization Code + PKCE. Avoid custom password storage if an external identity provider is available.

Access tokens are short-lived. Refresh tokens rotate. Use secure storage. Logout revokes server-side session/refresh capability where supported.

Staff/admin authentication uses a separate staff issuer/audience and mandatory MFA.

---

# 7. REQUIRED MOBILE/PWA SCREENS

Implement at least:

1. Splash
2. Language selection
3. Welcome/value proposition
4. Age-band selection (not exact DOB)
5. Privacy summary / essential terms
6. Guest entry
7. Sign in / Create account
8. Home
9. Check Something
10. Upload Preview / Redaction Confirmation
11. Analysis Processing
12. Analysis Result
13. Why this looks suspicious
14. What to do now
15. CyberBuddy
16. CyberBuddy conversation
17. Something Happened
18. Incident type selection
19. Triage questions
20. Incident Action Plan
21. Report / Get Help
22. Reporting Route Detail
23. Learn
24. Topic detail
25. Lesson
26. Quiz
27. Challenge
28. Challenge Result
29. Alerts
30. Alert Detail
31. Saved / History
32. Progress / Badges
33. Profile
34. Preferences
35. Language settings
36. Notification settings
37. Privacy & Data Controls
38. Delete Account
39. About / Disclaimer
40. Help / FAQ
41. Offline state
42. Error state
43. Maintenance state

Use Expo Router paths consistent with the supplied SRS.

---

# 8. HOME EXPERIENCE MUST BE SERVER-DRIVEN

Do not code the final home layout content directly into the client.

Create an API endpoint such as:

`GET /api/v1/experience/home?locale=en&ageBand=18_24`

Return a signed/versioned manifest containing only approved component schemas, for example:

```json
{
  "manifestVersion": 17,
  "locale": "en",
  "validFrom": "...",
  "validUntil": "...",
  "components": [
    {"type":"HERO","id":"...","contentRef":"..."},
    {"type":"ACTION_GRID","items":[...]},
    {"type":"ALERT_CARD","alertId":"..."},
    {"type":"CHALLENGE_CARD","challengeId":"..."},
    {"type":"CONTENT_CARD","contentId":"..."}
  ]
}
```

Implement:
- schema validation;
- server publishing workflow;
- ETag support;
- cache control/CDN readiness;
- last-known-good local cache;
- rollback;
- graceful failure to safe default navigation if manifest invalid.

Remote manifests must not carry executable code.

---

# 9. CHECK SOMETHING — CORE SECURITY FLOW

Supported MVP inputs:
- TEXT
- URL
- IMAGE (JPG/JPEG/PNG/WEBP)
- QR extracted from image

Maximum image size baseline: 10 MB, configurable.

## Client phase
1. validate type/size;
2. show privacy warning;
3. detect/redact obvious PII where feasible;
4. allow preview/confirmation;
5. never open submitted URLs automatically;
6. create analysis record;
7. upload image using a short-lived presigned URL to a quarantine bucket where applicable.

## Server/worker phase
1. verify actual MIME signature;
2. reject executable/polyglot/unsupported files;
3. strip metadata where applicable;
4. malware scan;
5. OCR text extraction;
6. QR extraction;
7. URL extraction and normalization;
8. PII redaction/sanitization;
9. domain parsing;
10. deterministic phishing/scam rule evaluation;
11. optional URL/domain reputation lookup;
12. AI structured explanation/classification;
13. deterministic policy combiner overrides/normalizes model result;
14. save minimized result/evidence metadata;
15. delete raw upload after processing according to configured short TTL;
16. return result.

## Risk labels
Only:
- LOW_CONCERN
- CAUTION
- HIGH_RISK
- INSUFFICIENT_INFORMATION

Do not use absolute `SAFE`.

## Result must include
- risk level;
- confidence band, not fake percentage precision;
- summary;
- 1–5 reasons;
- suspicious indicators;
- recommended actions;
- "already clicked/shared?" action;
- playbook shortcut;
- reporting/help shortcut when relevant;
- automation/AI limitation text;
- feedback controls.

---

# 10. DUAL-ENGINE SCAM DETECTION

The system must not rely solely on an LLM.

Implement:

## Deterministic engine
Versioned rules stored in backend/database, not hardcoded in the mobile client.

Examples:
- credential request;
- OTP request;
- urgency/threat language;
- impersonation;
- domain mismatch;
- IP-literal URL;
- suspicious Unicode/punycode/confusables;
- excessive subdomains;
- URL shorteners;
- fake prize;
- payment/gift card/crypto demand;
- job/scholarship fee request;
- remote-access software request;
- login/payment page indicator;
- known malicious reputation result.

Rule lifecycle:
`DRAFT → SIMULATED → SECURITY_REVIEWED → APPROVED → ACTIVE → RETIRED`

Support ruleset versioning, dry-run/simulation and rollback.

## AI engine
Use redacted evidence and deterministic indicators to produce structured JSON explanation.

AI may not directly invoke URLs or tools based on submitted content.

## Policy combiner
Final risk must be produced by application policy.
Examples:
- known malicious reputation => HIGH_RISK;
- OTP/password request + impersonation => at least HIGH_RISK;
- insufficient extractable content => INSUFFICIENT_INFORMATION;
- deterministic high-risk signal overrides an LLM low-risk answer;
- AI parsing failure falls back to deterministic result.

---

# 11. SSRF AND URL-SAFETY REQUIREMENTS

Any server-side URL inspection is security-sensitive.

Block:
- loopback;
- RFC1918/private IP ranges;
- link-local ranges;
- cloud metadata endpoints;
- internal DNS names;
- non-HTTP(S) schemes;
- suspicious redirect chains into blocked networks.

Resolve DNS safely and validate resolved addresses before connection and after redirect.
Use isolated egress/network policy where possible.
Never let the AI model perform arbitrary HTTP requests.

---

# 12. CYBERBUDDY RAG DESIGN

CyberBuddy is a multilingual digital-safety assistant.

MVP: Arabic + English.
Architecture must be French-ready.

## Mandatory RAG behavior
1. classify safety intent;
2. if high-risk, bypass normal generative answer and return an approved playbook/escalation response;
3. otherwise retrieve approved published knowledge chunks;
4. generate answer grounded in retrieved content;
5. return source references;
6. if verified content is insufficient, explicitly say so and provide safe generic guidance/reporting options.

Only `PUBLISHED`, non-expired, approved knowledge is retrievable.

Knowledge records require:
- source;
- source owner;
- publisher;
- locale;
- effective date;
- review due date;
- status;
- content hash/version.

Use PostgreSQL + pgvector hybrid retrieval and metadata filters.

Do not allow the model to silently answer authoritative reporting procedures only from its pretraining memory.

---

# 13. HIGH-RISK SAFETY INTENT OVERRIDE

Implement deterministic handling categories at minimum:

- GENERAL_SAFETY
- PHISHING
- ACCOUNT_COMPROMISE
- FINANCIAL_FRAUD
- HARASSMENT
- EXTORTION
- SEXTORTION
- CHILD_SAFETY
- PHYSICAL_DANGER

High-risk categories use approved content/playbooks and verified support routes.
Do not depend on simple keyword matching alone; support rules + classifier with conservative fallback.

Do not ingest or retain intimate images. If user attempts to submit disallowed sensitive material, stop upload and provide safe instructions without storing the content.

---

# 14. INCIDENT PLAYBOOK ENGINE

Playbooks are dynamic and declarative, not hardcoded page logic.

Initial playbook types:
- account hacked/taken over;
- suspicious link clicked;
- password shared;
- OTP/verification code shared;
- device lost/stolen;
- impersonation/fake profile;
- harassment/cyberbullying;
- blackmail/extortion;
- financial scam/loss;
- suspicious app/file installed/opened;
- account locked;
- AI/deepfake impersonation.

Each playbook supports:
- versions;
- steps;
- priority;
- warnings;
- branching rules;
- platform-specific variants;
- completion state;
- reporting route references;
- owner;
- approval status;
- effective/review dates.

Core recovery logic should be deterministic and testable.

---

# 15. REPORT / GET HELP

Reporting/support routes are database/CMS records, never hardcoded client URLs.

Fields:
- category;
- organization/platform;
- country/region;
- age restrictions;
- locale/languages;
- URL/phone/channel;
- hours;
- description;
- owner;
- verified_at;
- review_due_at;
- publication status.

Expired or unverified routes must stop appearing as current.
Show destination identity before opening an external link.
Do not claim endorsement unless formally authorized.

The MVP is a **routing service**, not a case-management repository.

---

# 16. DYNAMIC CYBER INTELLIGENCE & CONTENT ENGINE

This is mandatory.

Create:
- approved source registry;
- threat-source scheduler/ingestion jobs;
- source health/freshness checks;
- normalized threat items;
- deduplication/clustering;
- AI relevance classification;
- comparison to current published content/rules/playbooks;
- AI proposal records;
- human review tasks;
- publication workflow;
- rollback/versioning.

Possible approved source types:
- institutional cybersecurity advisories;
- CERT advisories;
- technology-platform security guidance;
- approved threat feeds;
- UNICEF/child-online-safety resources;
- approved digital-safety resources.

Do not make the source list immutable in code. Admins need to configure source registry entries with trust level, polling cadence, locale, owner and approval status.

AI proposal types:
- NEW_ALERT
- UPDATE_ALERT
- NEW_RISK_RULE
- UPDATE_RISK_RULE
- NEW_LESSON
- UPDATE_LESSON
- NEW_FAQ
- UPDATE_KNOWLEDGE
- UPDATE_PLAYBOOK
- NEW_CHALLENGE
- TRANSLATION_UPDATE
- RETIRE_CONTENT

AI proposals remain unpublished until approved.

---

# 17. CONTENT FRESHNESS

Implement three layers:

1. continuous automated monitoring;
2. event-driven human review when significant source changes occur;
3. periodic formal content assurance review.

Every content/rule/route/source record should support relevant freshness fields:
- effective_at;
- published_at;
- last_verified_at;
- review_due_at;
- expires_at;
- owner;
- version;
- status.

Add a background freshness job that flags overdue content and automatically hides/marks expired items according to policy.

---

# 18. COMMUNITY THREAT FEEDBACK LOOP

Users may submit lightweight feedback after analysis:
- HELPFUL
- NOT_HELPFUL
- INCORRECT
- CONFIRMED_SCAM (optional if product owner approves)

Use minimized/anonymized indicators to detect aggregate clusters.

Do not expose individual submissions to public dashboards.
Do not retain raw user content merely for clustering unless explicitly approved; prefer redacted features/hashes/derived indicators.

Admin dashboard may show emerging aggregate pattern candidates for review.

---

# 19. OFFLINE-FIRST PWA

Implement service worker/offline support for:
- core emergency playbooks;
- phishing checklist;
- password/2FA guidance;
- previously opened/downloaded lessons;
- core cyberbullying guidance;
- core AI-safety guidance;
- cached reporting routes with freshness metadata.

The following require connectivity:
- live AI analysis;
- current URL reputation;
- CyberBuddy live generation;
- latest threat alerts;
- threat-source ingestion;
- newly published content.

Show `Last verified` dates for cached help/reporting content.
Never imply that cached reputation/threat information is live.

---

# 20. LEARNING, QUIZZES, CHALLENGES AND BADGES

All learning content is CMS-driven.

Support:
- micro-lessons;
- scenario cards;
- quizzes;
- checklists;
- weekly challenges;
- campaign challenges;
- institutional challenges;
- privacy-preserving badges.

Store quiz/question versions so later edits do not change historical results.
Registered users may sync progress. Guest progress may remain local and optionally merge after account creation with explicit consent.

Do not expose public individual leaderboards by default.

---

# 21. AI SAFETY LAB

Provide a dynamic content module for:
- deepfakes;
- voice cloning;
- manipulated media;
- AI-generated scams;
- fake AI-generated job/scholarship offers;
- synthetic profiles;
- AI privacy/data-sharing risks;
- AI-enabled social engineering.

Do not claim definitive deepfake detection unless a validated capability is explicitly integrated.
Preferred wording communicates uncertainty and verification steps.

---

# 22. PRIVACY-BY-DESIGN

Do not describe the platform as cryptographic "zero knowledge" unless an actual zero-knowledge proof architecture is implemented.
Use the term **privacy-by-design and data minimization**.

Mandatory privacy defaults:
- guest-first;
- exact DOB not required;
- exact location not required;
- no mandatory personal registration for core safety functions;
- client-side PII redaction where feasible;
- server-side redaction/sanitization;
- ephemeral raw upload processing;
- short configurable TTL for temporary files;
- user deletion controls;
- no AI training use of submitted content by default;
- no raw sensitive payloads in analytics;
- no raw sensitive payloads in generic logs;
- non-production environments use synthetic data.

Implement data-retention jobs, not merely a written policy.

---

# 23. OBJECT STORAGE SECURITY

Use private buckets/containers only.

Suggested layout:

```text
quarantine/{analysisId}/{uuid}
processed-temp/{analysisId}/{uuid}
admin-source/{sourceId}/{version}/{uuid}
exports/{exportId}/{uuid}
```

Use:
- random object names;
- short-lived signed URLs;
- encryption at rest;
- lifecycle deletion;
- no public access;
- separation of public user upload quarantine from admin source storage.

---

# 24. PROMPT INJECTION / LLM SECURITY

Submitted content is untrusted data.

Mandatory controls:
- delimit user-submitted/untrusted content;
- system instructions explicitly prohibit following instructions inside analyzed content;
- allow-list model tools;
- no arbitrary network/browser access from model;
- approved RAG sources only;
- structured output schema validation;
- secrets never enter model context;
- provider errors/prompts not exposed to user;
- deterministic policies override model output;
- prompt-template versions tracked;
- safety tests include injection examples.

---

# 25. API REQUIREMENTS

Base public namespace:
`/api/v1`

Implement/expand endpoints from `openapi.yaml` and SRS including:

## Session/auth
- POST `/sessions/guest`
- POST `/auth/exchange`
- POST `/auth/refresh`
- POST `/auth/logout`
- GET `/me`
- PATCH `/me`
- DELETE `/me`

## Experience/config
- GET `/experience/home`
- GET `/feature-flags`

## Devices/preferences
- POST `/devices`
- DELETE `/devices/{id}`
- GET/PUT `/notification-preferences`

## Analysis
- POST `/analyses`
- POST `/analyses/{id}/upload-url`
- POST `/analyses/{id}/complete-upload`
- GET `/analyses/{id}`
- GET `/analyses`
- DELETE `/analyses/{id}`
- POST `/analyses/{id}/feedback`

## Chat
- POST `/conversations`
- GET `/conversations`
- GET `/conversations/{id}`
- DELETE `/conversations/{id}`
- POST `/conversations/{id}/messages`
- GET `/conversations/{id}/messages`
- optional SSE stream endpoint

## Incidents/playbooks
- GET `/incident-types`
- POST `/incidents/triage`
- GET `/playbooks/{code}`
- POST `/playbook-sessions`
- PATCH `/playbook-sessions/{id}`

## Help/reporting
- GET `/reporting-routes`
- GET `/reporting-routes/{id}`

## Content/learning
- GET `/content`
- GET `/content/{slug}`
- GET `/topics`
- GET `/search`
- quiz/challenge endpoints from SRS

## Alerts
- GET `/alerts`
- GET `/alerts/{id}`

## Admin
Separate `/api/admin/v1` namespace with staff SSO/RBAC.

Use a consistent response envelope and request IDs.
Never expose stack traces, SQL, prompt text, secrets, internal hosts, object keys or raw provider errors.

---

# 26. DATABASE REQUIREMENTS

Implement the supplied `DATABASE_SCHEMA.sql` using migrations.

Extend it as needed for dynamic architecture, including tables or equivalent structures for:
- experience manifests;
- manifest versions;
- feature flags;
- source registry;
- ingestion runs;
- normalized threat items;
- AI content proposals;
- review tasks;
- risk rule sets;
- risk rule versions;
- prompt templates;
- prompt template versions;
- content freshness state;
- publication workflow;
- rollback references.

Use PostgreSQL UUID primary keys and UTC `timestamptz`.
Add FK indexes and workload-specific indexes.
Use pgvector for knowledge embeddings.
Do not enable automatic schema synchronization in production.

---

# 27. REDIS / QUEUES

Use Redis for:
- rate limits;
- caching;
- queue coordination;
- short-lived analysis status;
- experience manifest cache;
- alert/reporting route cache;
- feature flags.

BullMQ queues:
- analysis
- ocr
- reputation
- embedding
- notification
- content-publish
- source-ingestion
- threat-clustering
- ai-proposals
- freshness-review
- retention-delete
- analytics-rollup

Every job needs:
- UUID job ID;
- correlation/request ID;
- idempotency key;
- timeout;
- retry policy;
- dead-letter behavior;
- structured logs.

---

# 28. NOTIFICATIONS

Push is opt-in and requested contextually after the user sees value.

Categories:
- verified cyber alerts;
- challenge reminders;
- learning reminders;
- account/security notifications.

No marketing notifications by default.
Support quiet hours.
Do not include sensitive incident content in push notifications.

---

# 29. LOCALIZATION AND ACCESSIBILITY

MVP languages:
- Arabic
- English

French-ready architecture.

Requirements:
- all UI strings externalized;
- Arabic RTL end-to-end;
- human-reviewed safety-critical translations;
- no runtime machine translation for emergency instructions;
- localized numbers/dates;
- no concatenated translation fragments;
- screen-reader labels;
- logical focus;
- dynamic text;
- large touch targets;
- adequate contrast;
- risk uses label + icon + color, never color alone;
- target WCAG 2.2 AA for web/PWA and equivalent native accessibility.

---

# 30. SECURITY BASELINE

Map verification and testing to:
- OWASP MASVS / MASTG for mobile;
- OWASP ASVS 5.x for backend/admin/web;
- OWASP LLM application security guidance for AI workflows.

Mandatory:
- TLS 1.2+, preferably TLS 1.3;
- secret vault;
- no client-bundled backend secrets;
- least privilege;
- RBAC;
- staff MFA;
- secure token storage;
- rate limiting;
- schema validation;
- output encoding;
- upload quarantine;
- malware scanning;
- SSRF controls;
- dependency/SCA scanning;
- SAST;
- DAST;
- container scanning;
- audit logging;
- security monitoring;
- database encryption/backups;
- no direct database exposure to Internet;
- no authorization decisions based only on client flags.

---

# 31. OBSERVABILITY AND LOGGING

Use OpenTelemetry and structured JSON logs.

Include:
- timestamp;
- service;
- environment;
- level;
- request_id;
- trace_id;
- route;
- status;
- duration;
- actor type;
- pseudonymous actor ID where necessary.

Never log:
- password;
- OTP;
- access/refresh token;
- Authorization header;
- raw screenshot;
- full sensitive chat content by default;
- push token plaintext;
- AI API key;
- URL query strings containing secrets.

Provide operational dashboards for:
- API error rate/latency;
- analysis duration/completion;
- queue depth;
- provider failure rate;
- AI fallback rate;
- source freshness;
- expired content/routes;
- notification delivery;
- DB/Redis health.

---

# 32. ANALYTICS

Use privacy-preserving events such as:
- app_opened
- onboarding_completed
- home_action_selected
- analysis_started/completed/failed
- analysis_feedback_submitted
- chat_started
- chat_safety_route_triggered
- playbook_started/step_completed
- reporting_route_opened
- lesson_started/completed
- quiz_completed
- challenge_completed
- alert_opened
- notifications_opted_in

Never send raw submitted content as analytics parameters.

Institutional dashboard is aggregated; do not expose individual youth behavioral profiles.

---

# 33. PERFORMANCE / AVAILABILITY TARGETS

Starting targets:
- CRUD/content API p95 < 500 ms excluding external dependencies;
- Home content p95 < 1 second with cache/CDN;
- analysis p50 < 5 sec, p95 < 15 sec under normal provider conditions;
- chat first token < 3 sec if streaming;
- warm-start interactive mobile target < 2 sec on mid-range supported devices;
- public API availability target 99.5% monthly for MVP excluding planned maintenance.

Build for horizontal API/worker scaling and Cybersecurity Week traffic bursts.

---

# 34. DEGRADATION / FAIL-SAFE BEHAVIOR

If AI provider is down:
- deterministic scanner still returns evidence-based indicators and generic safe next steps;
- incident playbooks work;
- lessons work;
- reporting routes work.

If reputation provider is down:
- continue rules + AI, and internally mark missing reputation evidence.

If OCR fails:
- allow crop/retake/paste-text path.

If manifest fetch fails:
- render last-known-good validated manifest or safe default navigation.

If offline:
- show cached emergency/learning content and clearly mark live functionality unavailable.

Never fabricate successful live checks when dependencies are unavailable.

---

# 35. TESTING REQUIREMENTS

## Unit tests
- rules engine;
- URL/domain parser;
- confusable detection;
- DTO validation;
- policy combiner;
- playbook engine;
- RBAC;
- content state machine;
- freshness logic;
- manifest validation;
- retention logic.

## Integration tests
- PostgreSQL;
- pgvector retrieval;
- Redis/BullMQ;
- object storage;
- malware scanner adapter;
- OCR adapter;
- reputation adapter;
- OIDC verification;
- AI provider mock.

## E2E
- first launch;
- guest session;
- optional login;
- Home manifest;
- text analysis;
- URL analysis;
- image upload/analysis;
- result/action flow;
- CyberBuddy;
- high-risk safety override;
- incident playbook;
- reporting route;
- lesson/quiz/challenge;
- notification preference;
- offline cache;
- deletion flow;
- Arabic RTL.

## Security tests
- authorization/BOLA;
- file-upload abuse;
- SSRF;
- XSS/content rendering;
- token theft/misuse;
- rate limiting;
- prompt injection;
- model data leakage;
- admin RBAC;
- malicious remote manifest;
- source/content poisoning;
- dependency/supply chain.

## AI evaluation dataset
Include benign, obvious phishing, ambiguous, Arabic, English, mixed-language, QR phishing, impersonation, scholarship/job scams, legitimate urgent messages, false-positive traps and prompt injections.

Track:
- confusion matrix;
- high-risk recall;
- false-positive rate;
- abstention rate;
- explanation correctness;
- action safety;
- source grounding rate;
- unsafe instruction refusal.

Re-run AI gates whenever model/provider/prompt/risk policy changes.

---

# 36. CI/CD

On every PR:
1. install locked dependencies;
2. format/lint;
3. strict type check;
4. unit tests;
5. contract tests;
6. secret scanning;
7. SAST;
8. dependency scanning;
9. builds;
10. migration validation;
11. container scan.

Staging:
12. deploy;
13. integration tests;
14. DAST/API security checks;
15. mobile/web E2E smoke tests;
16. AI evaluation suite;
17. accessibility checks;
18. manual production approval.

Production:
19. controlled migration;
20. progressive deployment;
21. health checks;
22. monitoring;
23. rollback if critical SLO/security failures occur.

---

# 37. LOCAL DEVELOPMENT ENVIRONMENT

Provide Docker Compose with at minimum:
- PostgreSQL + pgvector;
- Redis;
- MinIO;
- ClamAV;
- API;
- worker;
optional local mail/mock notification service.

Provide mock adapters for:
- AI provider;
- OCR;
- URL reputation;
- OIDC/dev auth where appropriate;
- push notifications.

A developer should be able to run a functional local environment without paid APIs.

---

# 38. IMPLEMENTATION PHASES

Do not attempt to build all functionality in an uncontrolled single pass.

## Milestone 0 — foundation
- monorepo;
- configs;
- Docker Compose;
- PostgreSQL/pgvector;
- Redis;
- MinIO;
- ClamAV;
- API/worker skeleton;
- mobile skeleton;
- admin skeleton;
- contracts;
- OpenAPI generation;
- logging/health checks;
- CI.

## Milestone 1 — onboarding + dynamic Home
- locale;
- RTL foundation;
- guest session;
- age band/privacy notice;
- experience manifest;
- last-known-good cache;
- Home rendering;
- settings.

## Milestone 2 — text/URL analysis
- analysis schema;
- deterministic rules;
- rule versioning;
- mock AI gateway;
- policy combiner;
- result UI;
- feedback;
- tests.

## Milestone 3 — image analysis
- presigned uploads;
- quarantine;
- MIME/security validation;
- malware scan;
- OCR/QR;
- redaction;
- deletion TTL;
- preview UI;
- tests.

## Milestone 4 — dynamic CMS + content lifecycle
- content schema;
- translations;
- source registry;
- review workflow;
- publish/expire/rollback;
- admin UI;
- content freshness jobs.

## Milestone 5 — CyberBuddy/RAG
- knowledge ingestion;
- chunking/embeddings;
- retrieval;
- safety classifier;
- deterministic high-risk override;
- chat UI;
- source references;
- evaluation tests.

## Milestone 6 — incident playbooks/help
- playbook schema/engine;
- triage;
- reporting routes;
- admin maintenance;
- mobile action plan;
- offline playbook caching.

## Milestone 7 — learning/challenges
- lessons;
- quizzes;
- progress;
- challenges;
- badges;
- guest local progress/account merge.

## Milestone 8 — threat intelligence/content proposals
- source ingestion scheduler;
- normalized threat items;
- clustering;
- AI proposal queue;
- review/publish workflow;
- risk rule proposal flow;
- admin dashboard.

## Milestone 9 — alerts/notifications
- verified alerts;
- scheduling;
- categories;
- push opt-in;
- quiet hours;
- deep links.

## Milestone 10 — hardening
- retention/deletion;
- threat model validation;
- penetration-test preparation/remediation;
- load tests;
- accessibility;
- offline resilience;
- AI evaluation gates;
- backup/restore;
- operational runbooks.

---

# 39. REQUIRED ACCEPTANCE GATES

The MVP cannot be considered complete unless:

1. guest user can reach Home and run text/URL checks without registration;
2. image upload is securely quarantined/scanned/OCR processed and deleted according to retention policy;
3. every analysis result includes uncertainty language and actionable steps;
4. high-risk result can launch an approved recovery playbook;
5. CyberBuddy uses approved published sources or explicitly states insufficient verified information;
6. high-risk safety intents bypass unrestricted generation;
7. no draft content appears publicly;
8. expired reporting/help routes do not appear as current;
9. dynamic Home/content works without app release;
10. invalid remote configuration cannot break the client;
11. Arabic RTL works across core flows;
12. user deletion/history deletion works;
13. core playbooks/content are available offline;
14. sensitive payloads do not appear in logs/analytics;
15. agreed MASVS/ASVS/LLM security gates pass;
16. AI evaluation meets product-owner-approved thresholds;
17. CI/CD and rollback are working;
18. admin changes are auditable;
19. production content/rules/playbooks are not hardcoded in the mobile client;
20. app degrades safely if AI/reputation services are unavailable.

---

# 40. CODING RULES

- TypeScript strict mode.
- No `any` unless documented and unavoidable.
- Validate boundary data with Zod/class-validator as appropriate.
- Never trust client-provided role/ownership IDs.
- Use parameterized queries/ORM.
- No secret values in git.
- No production URLs/phone numbers embedded in client code; use dynamic reporting routes.
- No safety-critical free-form JSON without schema validation.
- No unreviewed AI-generated content published automatically.
- No direct model calls from mobile/admin clients.
- No direct public object storage access.
- No raw sensitive logs.
- No `synchronize: true`/equivalent production DB auto-sync.
- No arbitrary remote UI code.
- No unsafe HTML rendering of CMS content.
- Keep test fixtures synthetic.

---

# 41. EXPECTED OUTPUT FROM THE AI ENGINEERING AGENT

At each milestone, output/commit:

1. implementation code;
2. migrations;
3. tests;
4. updated OpenAPI;
5. updated documentation;
6. ADRs for deviations;
7. a short changelog;
8. security/privacy notes;
9. commands to run locally;
10. known limitations;
11. next milestone tasks.

Do not claim functionality exists unless it is implemented and tested.
Do not silently leave critical endpoints as stubs in a milestone marked complete.

---

# 42. FIRST EXECUTION INSTRUCTION

Start with **Milestone 0** only.

Before writing feature code:
1. inspect all supplied files;
2. produce a concise implementation plan and dependency map;
3. initialize the monorepo;
4. create shared TypeScript/ESLint/Prettier config;
5. create Expo mobile app with Expo Router;
6. create NestJS API and worker;
7. create Next.js admin app;
8. add PostgreSQL + pgvector, Redis, MinIO and ClamAV Docker Compose services;
9. configure Prisma/migrations based on the supplied schema;
10. add shared contracts package;
11. add `/health/live` and `/health/ready` endpoints;
12. add OpenTelemetry/structured logging skeleton;
13. add GitHub Actions baseline;
14. add mock adapters;
15. run all builds/tests;
16. document setup in README;
17. stop and report Milestone 0 completion, test results and any ADRs before moving to Milestone 1.

Once Milestone 0 is accepted, proceed sequentially through the remaining milestones.

---

# 43. PRODUCT OWNER DECISIONS THAT MUST REMAIN CONFIGURABLE UNTIL APPROVED

Do not invent permanent values for:
- exact age-policy boundaries;
- under-13 support;
- official public identity provider;
- production cloud/hosting location;
- AI provider/model;
- embedding model;
- threat/reputation providers;
- exact retention periods;
- official reporting organizations;
- direct reporting integrations;
- safeguarding escalation partners;
- final French launch status;
- notification cadence;
- analytics consent/legal basis;
- leaderboard policy;
- final visual brand assets.

Implement adapters/configuration so these decisions can be supplied later.

---

# 44. FINAL DEVELOPMENT PRINCIPLE

CyberSafe Lebanon is **not an app with static cybersecurity content**.

It is a **dynamic cyber-safety platform** whose PWA/mobile client is one delivery channel. The system must remain useful as scams, AI threats, platforms, security recommendations and user needs evolve.

Build the product so that most content, threat guidance, rules, campaigns and playbooks can be safely updated through controlled backend workflows **without publishing a new app version**, while security-critical application code and trust boundaries remain fixed, reviewed and release-controlled.
