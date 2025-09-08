# Backlog Index

This directory seeds the initial product & engineering backlog derived from `docs/requirements.md`.

## Epic Overview
| Epic ID | File | Theme |
|---------|------|-------|
| EPIC-IDENTITY-AUTHZ | epics/EPIC-IDENTITY-AUTHZ.md | Identity & Authorization |
| EPIC-SYLLABUS-MGMT | epics/EPIC-SYLLABUS-MGMT.md | Syllabus & Lesson Templates |
| EPIC-LESSON-RECORDING | epics/EPIC-LESSON-RECORDING.md | Lesson Recording & Amendments |
| EPIC-STAGE-CHECKS | epics/EPIC-STAGE-CHECKS.md | Stage Checks |
| EPIC-ENDORSEMENTS | epics/EPIC-ENDORSEMENTS.md | Endorsements |
| EPIC-REPORTING-EXPORTS | epics/EPIC-REPORTING-EXPORTS.md | Reporting & Exports |
| EPIC-AUDIT-COMPLIANCE | epics/EPIC-AUDIT-COMPLIANCE.md | Audit & Compliance |
| EPIC-NOTIFICATIONS | epics/EPIC-NOTIFICATIONS.md | Notifications (MVP subset) |
| EPIC-PLATFORM-INFRA | epics/EPIC-PLATFORM-INFRA.md | Platform Infrastructure |

## Suggested Label Conventions
- `epic`
- `story`
- `bug`
- `tech-debt`
- `security`
- `performance`
- `documentation`
- `blocked`
- `needs-design`

## Story ID Pattern
`STORY-<EPIC-SHORT>-NNN` — keep IDs stable when creating GitHub issues. Reference functional requirement IDs (e.g., F-060) in issue body.

## Initial Prioritization
High: Core identity, syllabus, lesson recording, stage checks, endorsements, platform infrastructure.
Medium: Reporting exports (basic), notifications subset, audit querying.
Low: Advanced filters, integrity background job, environment promotion optimization.

## Workflow Guidance
1. Create GitHub issues from each story row (copy table row details).
2. Assign labels: `story`, epic-specific label, and any cross-cutting (e.g., `security`).
3. Link story issues to parent epic using GitHub Projects or issue linking (`parent/child`).
4. Track acceptance criteria in issue body; mark completed with checklist at PR closure.
5. Keep epic file updated (append new stories or status sections as scope evolves).

## Definition of Ready Checklist (Stories)
- Clear user value statement (As a <persona> ...)
- Acceptance hints or explicit criteria
- Dependencies identified
- Non-functional implications noted (performance, security) if relevant
- Test approach sketched (unit/integration) if complex

## Definition of Done Checklist (Stories)
- Code merged & reviewed
- Unit tests added/passing
- Integration tests (if endpoint) updated
- Documentation / API spec updated
- Observability (logs/metrics) added if new pathway
- Security/RBAC verified

## Future Backlog Management Enhancements
- Automate generation of issues via script parsing markdown tables.
- Add project board automation (status columns: Backlog, Ready, In Progress, Review, Done).
- Add conventional commit enforcement pre-merge.

---
Generated: 2025-09-06
