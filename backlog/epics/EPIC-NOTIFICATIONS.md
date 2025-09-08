# Epic: Notifications & Alerts (MVP Subset)

Epic ID: EPIC-NOTIFICATIONS
Labels: epic, notifications
Related Requirements: F-140, F-141, F-142

## Goal
Provide timely email notifications for critical training events (stage-check assignments/results) and workflow hygiene (stale drafts).

## Success Metrics
- Email dispatch success rate ≥ 99% (measured via provider response).
- Draft stale reminder accuracy (no reminder after finalize) 100% sample.

## User Stories
| Story ID | Title | Description | Acceptance Hints | Priority |
|----------|-------|-------------|------------------|----------|
| STORY-NOTIF-001 | Stage Check Assignment Email | As a student I want an email when a stage check is assigned so that I can prepare. | Template variables correct. | High |
| STORY-NOTIF-002 | Stage Check Result Email | As a student I want an email after evaluation so that I know outcome promptly. | Outcome included. | High |
| STORY-NOTIF-003 | Stale Draft Reminder | As an instructor I want reminders for drafts older than threshold so that I finalize promptly. | Threshold configurable (default 24h). | Medium |

## Risks / Mitigations
| Risk | Mitigation |
|------|------------|
| Email spam/noise | Unsubscribe / frequency config (future) |
| Provider outage | Queue + retry with exponential backoff |

## Dependencies
- Epic: Stage Checks
- Epic: Lesson Recording

## Definition of Done
- Email templates versioned
- Retry policy implemented
- Metrics: send latency + failure count in App Insights
