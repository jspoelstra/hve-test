# Epic: Audit & Compliance Logging

Epic ID: EPIC-AUDIT-COMPLIANCE
Labels: epic, audit, compliance
Related Requirements: F-160, F-161, F-162, Security Section

## Goal
Provide immutable, queryable audit trails for all mutating and security-relevant actions to satisfy internal governance and external regulatory review.

## Success Metrics
- 100% mutate endpoints produce audit entry.
- Audit write latency < 2s P95.
- Query by actor and date range returns expected entries in test harness.

## User Stories
| Story ID | Title | Description | Acceptance Hints | Priority |
|----------|-------|-------------|------------------|----------|
| STORY-AUD-001 | Log Mutations | As the system I must record create/update/delete so that history is preserved. | Entry with entityType/id. | High |
| STORY-AUD-002 | Log Auth Events | As the system I must record auth success/failure so that security anomalies are traceable. | actionType=AUTH_SUCCESS/FAIL. | High |
| STORY-AUD-003 | Query Audit | As an admin I want to filter audit logs so that I can investigate issues. | Date + actor filters. | Medium |
| STORY-AUD-004 | Export Audit CSV | As an auditor I want to export logs so that I can archive them. | CSV generation, column headers fixed. | Medium |

## Risks / Mitigations
| Risk | Mitigation |
|------|------------|
| High volume cost | Partitioning + retention window config |
| PII exposure in metadata | Redact strategy + field allowlist |

## Dependencies
- All epics producing mutations
- Platform logging infrastructure

## Definition of Done
- Schema finalized & documented
- Load/perf test for sustained write throughput
- Security review of redaction rules
