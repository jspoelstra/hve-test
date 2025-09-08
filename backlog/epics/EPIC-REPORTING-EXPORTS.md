# Epic: Reporting & Exports

Epic ID: EPIC-REPORTING-EXPORTS
Labels: epic, reporting, exports
Related Requirements: F-120, F-121, AC-05, NFR (Performance, Observability)

## Goal
Deliver structured, performant exports of student and aggregate training data to satisfy audit, transfer, and operational insight needs.

## Success Metrics
- Student record export (<50 lessons) completes synchronously < 3s.
- Large export (>50 lessons) async job completes < 2m 95% of time.
- 0 data field omissions in validation checklist.

## User Stories
| Story ID | Title | Description | Acceptance Hints | Priority |
|----------|-------|-------------|------------------|----------|
| STORY-RPT-001 | Export Student Record | As an admin I want to export a student's full record so that I can provide it externally. | PDF + JSON artifacts created. | High |
| STORY-RPT-002 | Async Large Export | As the system I must offload large exports so that users aren't blocked. | Job status polling endpoint. | Medium |
| STORY-RPT-003 | Metrics Dashboard Data API | As an admin I want metrics so that I can assess throughput. | Aggregates: pass rates, avg completion time. | Medium |
| STORY-RPT-004 | Filtered Reports | As an admin I want to filter reports by instructor/date so that I can focus insights. | Query params validated. | Low |

## Risks / Mitigations
| Risk | Mitigation |
|------|------------|
| Long-running synchronous exports | Size threshold switch to async queue |
| PII leakage in exports | Field whitelist + security review |

## Dependencies
- Epic: Lesson Recording
- Epic: Stage Checks
- Epic: Endorsements

## Definition of Done
- Export size threshold documented
- Blob SAS expiry policy defined
- Unit/integration tests produce deterministic JSON
