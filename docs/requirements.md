# Flight School Student Record Management System

## 1. Vision & Goals
A secure, role-aware, cloud-native web application enabling flight school stakeholders (Students, Certified Flight Instructors (CFIs), Stage-Check / Check Instructors, Dispatch / Ops, and Administrators) to manage training progress, flight / ground lesson records, endorsements, stage checks, and regulatory compliance (FAA Part 61/141 concepts) while improving transparency, data integrity, and operational efficiency.

Primary goals:
- Centralize authoritative student training records & endorsements.
- Provide real‑time progress visibility (syllabus, stage, lesson completion) to all relevant parties.
- Reduce administrative overhead, duplicate data entry, and paper reliance.
- Enforce data consistency, auditability, and FAA-aligned retention.
- Support scalable, secure, multi-device access with strong identity and authorization controls.

Non-goals (explicit exclusions for v1):
- Flight scheduling / aircraft maintenance tracking (integrations may be future scope).
- Full accounting / billing system.
- Electronic signature capture beyond instructor attestation (advanced PKI later).

## 2. Personas & Stakeholders
| Persona | Description | Key Needs |
|---------|-------------|-----------|
| Student | Enrolled trainee pilot | See progress, upcoming lessons, deficiencies, instructor feedback, endorsements |
| CFI (Instructor) | Delivers instruction, logs lessons | Fast lesson entry, syllabus guidance, deficiency tracking, endorsements, analytics |
| Stage-Check Instructor | Performs milestone evaluations | Access to history, evaluation rubric, pass/fail & remediation workflow |
| Chief Instructor / Admin | Oversees program quality & compliance | Global dashboard, metrics, override controls, user & syllabus management |
| Dispatch / Ops Staff | Optional read/report view | Verify eligibility (endorsements, currency) |
| System Administrator (Tech) | Manages platform | User provisioning, roles, configuration, auditing |
| External Auditor (Read-only) | Compliance review | Immutable read-only access to historical data |

## 3. High-Level Functional Scope
### 3.1 User & Identity Management
- Azure Entra ID B2C (or standard Entra if internal) integration for authentication.
- Role-based authorization (RBAC) with fine-grained resource-level permissions.
- Support for multi-tenant (future): separate schools (Phase 2). v1 single-tenant.
- User lifecycle: Invite → Register → Activate → Deactivate (soft delete) → Archive.

### 3.2 Student Profiles
- Core demographics (name, contact, student ID, enrollment date, medical class/expiration, TSA clearance status where applicable).
- License / rating objectives (e.g., PPL, Instrument, Commercial) with separate syllabus instances per objective.
- Status indicators: Active, On Hold, Completed, Withdrawn.

### 3.3 Syllabus & Lesson Management
- Define syllabus templates: phases/stages → lessons (ground / flight) → objectives.
- Versioning of syllabus templates (immutable once applied to a student; new version applies only to new enrollments unless migrated deliberately).
- Lesson instance creation per student with tracking: assigned, in-progress, completed, needs-remediation.
- Objective attainment tracking (met / partial / not met) with instructor remarks.

### 3.4 Lesson / Flight Record Entry
- Quick-entry form for CFIs: date, aircraft tail (optional placeholder), simulator flag, hobbs/tach time (optional), maneuvers practiced, weather conditions (optional), night / XC / instrument time buckets (future extension placeholders), remarks.
- Validation: cannot finalize without required objective assessments.
- Draft vs Final states; only final counts toward progress metrics.
- Edit restrictions: Edits after final require reason & audit trail; stage-check signed records locked.

### 3.5 Stage Checks & Evaluations
- Scheduled stage evaluations referencing syllabus stage.
- Structured evaluation rubric with pass/fail/partial & remediation tasks.
- Ability to assign remedial lessons flagged separately.
- Locking: Once signed off by stage-check instructor and acknowledged by student, record becomes immutable (append-only corrections).

### 3.6 Endorsements & Regulatory Items
- Library of standard FAA endorsement templates (placeholder; not legal advice) with mail-merge tokens (student name, certificate number, date, instructor cert number, expiration).
- Issuance workflow: instructor selects template, customizes note, signs (attestation). Stored with hash to prevent tampering.
- Active vs Expired endorsements (e.g., TSA, 90-day currency - some derived / computed in future).

### 3.7 Progress Dashboards
- Student dashboard: syllabus percent complete, upcoming lessons, deficiencies, last activity date.
- Instructor dashboard: roster, lessons pending finalization, remediation queues.
- Admin dashboard: training throughput metrics (avg time to completion, pass rates), compliance exceptions.

### 3.8 Reporting & Exports
- Export student training record (PDF + JSON) for transfer or audit.
- Aggregate metrics (by instructor, by stage, by date range).
- Audit log export (CSV) with filters (user, action, entity type, date).

### 3.9 Notifications & Alerts (Phase 1 MVP subset)
- Email notification on stage-check assignment & result posting.
- Reminder for expiring medical (30 days pre-expiry). (Optional toggle.)
- Instructor reminder for lessons left in Draft > 24h.

### 3.10 Compliance & Audit
- Immutable audit log: CRUD events, auth events, role changes, endorsement issuance, stage-check sign-offs.
- Time-stamped UTC, actor identity (GUID), previous value hash optional.

### 3.11 Administration
- Manage syllabus templates (create, clone, version, retire).
- Manage roles & user assignments.
- System configuration: retention policies, feature toggles (e.g., notifications), email sender profiles.

### 3.12 Accessibility & UX
- WCAG 2.1 AA alignment.
- Mobile-responsive design (tablet-friendly for cockpit debrief scenario).

## 4. Out-of-Scope (Explicit)
- Payment processing.
- Real-time aircraft scheduling optimization.
- EFB (Electronic Flight Bag) integration (future integration hook endpoints may be added later).
- Complex weather ingestion, flight tracking telemetry.

## 5. Detailed Functional Requirements (Selected Highlights)
Each requirement tagged: F-###. (Full backlog to be elaborated in Azure Boards / Jira.)

### 5.1 Identity & Access
- F-001: System SHALL authenticate users via Azure Entra ID / B2C using OAuth2/OIDC flows.
- F-002: System SHALL enforce RBAC with roles: Student, Instructor, StageCheckInstructor, Admin, Auditor, OpsReadOnly.
- F-003: System SHALL restrict Students to their own records (read) except where explicitly allowed (e.g., group leaderboard - future).
- F-004: System SHALL allow Admins to assign multiple roles to a single user (union of permissions).
- F-005: System SHALL log all authentication failures and success events.

### 5.2 Syllabus Templates
- F-020: Admin SHALL create syllabus templates containing: metadata (name, version, objective), ordered stages, ordered lessons, lesson objectives.
- F-021: System SHALL lock a syllabus version once at least one student instance exists.
- F-022: System SHOULD support cloning an existing version to accelerate iteration.
- F-023: System SHALL maintain backward compatibility for students mid-training when a new version is introduced.

### 5.3 Student Syllabus Instantiation
- F-040: On enrollment to a rating, System SHALL instantiate lesson plan from template.
- F-041: System SHALL track per lesson status and completion timestamp.
- F-042: System SHALL compute percent complete: completed lessons / total lessons (excludes retired lessons not instantiated).

### 5.4 Lesson Recording
- F-060: Instructor SHALL be able to save a lesson record in Draft before finalizing.
- F-061: Finalization SHALL require all mandatory objectives assessed.
- F-062: System SHALL prevent deletion of finalized record; only append corrective amendments (F-063).
- F-063: Amendments SHALL generate new audit log entry referencing original record ID.

### 5.5 Stage Checks
- F-080: Stage check record SHALL include evaluation rubric with at least: date, evaluator, outcome (Pass/Conditional/Fail), notes, remediation tasks (array), sign-off timestamp.
- F-081: Conditional / Fail outcomes SHALL require at least one remediation task.
- F-082: System SHALL mark stage as complete only on Pass.

### 5.6 Endorsements
- F-100: Instructor SHALL select from endorsement templates and issue to a student.
- F-101: System SHALL generate an immutable endorsement record with hash (SHA-256) of structured content for tamper detection.
- F-102: Endorsements SHALL display active/expired based on rule set (template metadata).

### 5.7 Reporting
- F-120: Admin SHALL export student full record (PDF + machine-readable JSON) including lessons, stage checks, endorsements, audit excerpts.
- F-121: System SHOULD allow filtering reports by date range, instructor, or rating.

### 5.8 Notifications
- F-140: System SHALL send email for stage-check assignment (to student + evaluator).
- F-141: System SHALL send email for stage-check result posted.
- F-142: System SHOULD send reminder for drafts older than 24h (configurable threshold).

### 5.9 Audit & Compliance
- F-160: System SHALL maintain append-only audit log with fields: id, timestamp (UTC), actorUserId, actionType, entityType, entityId, priorValueHash (optional), metadata JSON.
- F-161: Audit entries SHALL be queryable by date range and actor.
- F-162: System SHOULD provide export in CSV.

### 5.10 Administrative
- F-180: Admin SHALL deactivate (soft delete) a user; user cannot re-authenticate but historical data retained.
- F-181: System SHALL flag inactive students to exclude from active progress dashboards.

## 6. Non-Functional Requirements (NFRs)
| Category | Requirement |
|----------|-------------|
| Availability | Target 99.5% monthly uptime (Phase 1) ; design path to 99.9%. |
| Performance | P95 page interactive < 2.5s on broadband; API P95 < 500ms for standard queries (<50KB payload). |
| Scalability | Support 500 concurrent users & 100k total lesson records without re-architecture. |
| Security | All data in transit TLS 1.2+, at rest encryption (Azure SQL TDE, Storage SSE). No sensitive secrets in code. |
| Privacy | Only minimum necessary PII stored; support Right to Export (self-service) (Phase 2). |
| Auditability | 100% of mutating actions generate audit log entry within 2s. |
| Observability | Structured logs + Application Insights traces + basic metrics (requests/sec, error rate, latency) + availability tests. |
| Reliability | Graceful degradation of reporting (async job) if load spike. Retry transient DB & storage errors with exponential backoff. |
| Maintainability | Modular service/domain layers; >70% unit test coverage for domain logic by Beta. |
| Accessibility | WCAG 2.1 AA for forms, contrast, keyboard navigation. |
| Localization | English only v1; architecture prepared for i18n keys. |
| Data Retention | Minimum 5 years retention of training records/audit; purge policy configurable (Phase 2). |
| Disaster Recovery | RPO <= 15 min (Geo-Replication Azure SQL optional Phase 2); RTO <= 4 hours. |

## 7. Data Model (Conceptual Overview)
Key Entities (CamelCase names map to table/collection names):
- User (id, externalAuthId, roles[], status, createdAt, deactivatedAt)
- StudentProfile (id, userId FK, studentNumber, medicalClass, medicalExpiresOn, enrollmentDate, status)
- SyllabusTemplate (id, version, name, ratingType, status, createdBy, createdAt, supersedesTemplateId?)
- SyllabusStageTemplate (id, syllabusTemplateId, orderIndex, name)
- LessonTemplate (id, syllabusStageTemplateId, orderIndex, lessonType:Flight|Ground, title, objectives[Objective])
- Objective (id, lessonTemplateId, code, description, isMandatory)
- StudentSyllabus (id, studentProfileId, syllabusTemplateId, ratingType, createdAt, status)
- StudentLesson (id, studentSyllabusId, lessonTemplateId, status, startedAt, finalizedAt, amendedFromId?)
- StudentLessonObjective (id, studentLessonId, objectiveId, assessment:Met|Partial|NotMet, remarks)
- StageCheck (id, studentSyllabusId, stageTemplateId, evaluatorUserId, outcome, notes, remediationTasks JSON[], signedAt)
- EndorsementTemplate (id, code, title, bodyTemplate, validityDays?)
- EndorsementIssued (id, studentProfileId, templateId, issuedByUserId, issuedAt, expiresAt, contentSnapshot JSON, contentHash)
- AuditLog (id, timestamp, actorUserId, actionType, entityType, entityId, priorValueHash, metadata JSON)
- Notification (id, type, userId, status:Pending|Sent|Failed, payload JSON, createdAt, sentAt)

### Indexing & Query Considerations
- Composite indexes: (studentSyllabusId, status), (studentProfileId, createdAt desc), (templateId, version desc).
- High cardinality caution on audit: partition by month or use time-based table w/ retention.

## 8. API Surface (Initial High-Level)
(REST JSON, versioned `/api/v1/`):
- Auth handled by Entra ID (bearer tokens); minimal custom endpoints for token introspection (none if standard). 
- `GET /students/{id}`
- `GET /students/{id}/syllabi`
- `POST /students/{id}/syllabi` (instantiate)
- `GET /syllabi/templates` / `POST /syllabi/templates` / `POST /syllabi/templates/{id}/clone`
- `GET /lessons/{id}` / `PATCH /lessons/{id}` (draft updates) / `POST /lessons/{id}/finalize` / `POST /lessons/{id}/amend`
- `POST /stage-checks` / `GET /stage-checks/{id}` / `POST /stage-checks/{id}/sign`
- `POST /endorsements` / `GET /students/{id}/endorsements`
- `GET /reports/students/{id}` (export) / `GET /reports/metrics`
- `GET /audit` (filter params)
- `POST /notifications/dispatch` (internal service or queue trigger)

## 9. Architecture Overview (Target Azure Components)
- Web Frontend: Azure Static Web Apps or Azure App Service (depending on SSR needs) (Phase decision TBD). MVP assumption: React SPA + Azure Static Web Apps.
- Backend API: Azure App Service (Container or .NET/Node runtime) or Azure Functions (HTTP triggers) – MVP choose App Service for simpler session + long-lived endpoints.
- Database: Azure SQL Database (transactional consistency, relational model) with Elastic Pool option for multi-tenant future; use Always Encrypted for sensitive fields if needed.
- Storage: Azure Blob Storage for exports & large artifacts (PDF). Private container + SAS for time-bound download.
- Identity: Azure Entra ID / B2C (if external self-registration). Use roles claims mapping.
- Caching: Azure Cache for Redis (Phase 2) for syllabus templates, reference data.
- Messaging / Background Jobs: Azure Storage Queues or Service Bus (Phase 2) for async notifications/report generation.
- Observability: Azure Application Insights + Log Analytics workspace.
- Key Management: Azure Key Vault (connection strings (if not using managed identity), signing keys for hash salting, email provider secrets).
- CI/CD: GitHub Actions → deploy via `azd` or ARM/Bicep templates.

## 10. Security & Compliance Requirements
- Enforce HTTPS everywhere; redirect HTTP → HTTPS.
- Use Managed Identity for Azure SQL access (no passwords in config) where feasible; otherwise store secrets in Key Vault.
- Role claims validated server-side on each request.
- Input validation & output encoding to mitigate OWASP Top 10; server-side enforcement (never trust client states like Draft vs Final).
- Tamper detection for endorsements via SHA-256 hash of canonical JSON representation.
- Least privilege: separated App Service identity vs deployment principal.
- Logging of security events (auth failures, role modifications) to dedicated log category.
- Regular access review (Admin UI report listing last login per user). (Phase 2 automation.)
- Data encryption: TDE (SQL) + SSE (Blob) + HTTPS; optional column encryption (medical expiration maybe not necessary PII classification baseline: moderate).
- Backups: Automated SQL backup with geo-redundant storage (Phase 2 geo-secondary). Verify restore quarterly (runbook documentation).

## 11. Observability & Monitoring
- Application Insights: request metrics, dependency metrics (SQL, Key Vault), custom events (StageCheckSigned, EndorsementIssued).
- Log retention: 90 days hot, archive to storage after 90 → 365 days (Phase 2).
- Alert rules: P95 latency > 800ms sustained 10m; Error rate > 2% 5m; Failed login spikes > threshold.
- Dashboard workbook summarizing training throughput & system health.

## 12. Data Migration & Seeding
- Admin bootstrap script to load initial syllabus templates and endorsement templates.
- Migration framework (e.g., EF Core migrations if .NET) with idempotent seed steps.

## 13. Testing Strategy
- Unit tests: domain services (objective evaluation validation, progress calculation, endorsement hashing).
- Integration tests: API endpoints with in-memory / containerized SQL.
- Security tests: authZ rules (role matrix), IDOR prevention.
- Performance test: baseline load (500 concurrent lesson fetch) pre-GoLive.
- UAT: Scenario scripts (Enroll student → record lessons → stage check → export record).

## 14. Release & Deployment
- Branch strategy: trunk (main) + short-lived feature branches; PR validation pipeline (lint, tests, build, SAST). 
- Environments: Dev, QA, Prod (separate resource groups). Future: Staging (blue/green).
- Infra as Code: Bicep (folder `infra/`) – future deliverable.
- Deployment gating: manual approval to Prod after QA test pass + security scan.

## 15. Risks & Mitigations
| Risk | Impact | Mitigation |
|------|--------|-----------|
| Scope creep (add scheduling) | Delays MVP | Document non-goals; backlog triage cadence |
| Complex syllabus version migration | Data inconsistency | Immutable per version; explicit migration tool later |
| Overly granular objectives causing instructor friction | Adoption risk | UX research + incremental template refinement |
| Audit log volume cost | Cost overrun | Partitioning + retention policy + compression |
| Vendor lock-in | Portability concerns | Clean domain layer, abstract persistence, avoid proprietary SQL extensions |
| Security misconfiguration (secrets) | Data breach | Managed Identity + Key Vault + devsecops scanning |

## 16. Open Questions (Track & Resolve)
| ID | Question | Owner | Target Resolution |
|----|----------|-------|-------------------|
| Q1 | Use B2C or standard Entra (are students external)? | Product | Pre-Architecture Review |
| Q2 | Require e-signature compliance for endorsements? | Compliance | Legal Review |
| Q3 | Multi-tenant requirement timeline? | Product | Roadmap Q4 |
| Q4 | Data classification level (medical info minimal)? | Security | Data Governance Mtg |

## 17. MVP Definition (Cut Line)
Included in MVP:
- Authentication & RBAC
- Syllabus templates (basic) & instantiation
- Lesson recording (draft/final)
- Stage checks (pass/fail) without complex remediation workflow UI (basic text tasks)
- Endorsement issuance & hash
- Student & Instructor dashboards (basic KPIs)
- Export student record PDF (minimal styling) + JSON
- Audit logging core actions

Deferred (Post-MVP):
- Notifications beyond stage-check & draft reminders
- Advanced analytics dashboards
- Redis caching layer
- Multi-tenant isolation
- Automated access review reports
- Column encryption extras
- Message queue based async processing

## 18. Acceptance Criteria (Representative)
- AC-01: Given a valid instructor token, when creating a lesson draft missing mandatory objective assessments, then API responds 400 with validation errors.
- AC-02: Given a finalized lesson, when an amendment is submitted, then original remains immutable and a new record references it via `amendedFromId`.
- AC-03: Given a stage check pass, when querying syllabus progress, stage status shows complete within <5s.
- AC-04: Given an issued endorsement, when retrieving endorsements list, its `contentHash` matches recomputed hash server-side.
- AC-05: Given an admin export request, when student has >50 lessons, export completes (async if >10MB) and download link provided (SAS URL expiry 10 minutes).
- AC-06: Given an unauthorized student token, when requesting another student's profile, responds 403 (no data leakage). 

## 19. Traceability Matrix (Abbreviated Example)
| User Story | Requirement(s) | Acceptance Criteria |
|------------|----------------|---------------------|
| As a CFI I record a lesson | F-060..F-063 | AC-01, AC-02 |
| As a stage-check instructor I sign evaluation | F-080..F-082 | AC-03 |
| As admin I export full record | F-120 | AC-05 |
| As student I view only my data | F-001..F-005 | AC-06 |

## 20. Future Enhancements (Backlog Seeds)
- Real-time collaboration (simultaneous instructor note editing) via SignalR.
- Integration with scheduling systems (Chronos, FlightSchedulePro) via webhook adapters.
- API keys / service principals for external data export automation.
- Advanced competency-based training model support.
- Data warehouse ETL to Azure Synapse / Fabric for BI.
- Mobile PWA offline lesson draft capture.
- AI-assisted debrief summarization.

---
Document Version: 0.1 (Initial Draft)
Prepared: 2025-09-06
