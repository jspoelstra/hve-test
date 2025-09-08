# Epic: Lesson Recording & Amendments

Epic ID: EPIC-LESSON-RECORDING
Labels: epic, lessons, instruction
Related Requirements: F-060, F-061, F-062, F-063, NFR (Auditability, Performance)

## Goal
Provide instructors with an efficient workflow to draft, finalize, and (if needed) amend lesson records while ensuring integrity and auditability of training history.

## Success Metrics
- Average draft entry time < 90 seconds (UX benchmark).
- 0% data loss incidents on finalize/amend operations.
- Audit log entry generated within 2s for finalize and amend actions.

## User Stories
| Story ID | Title | Description | Acceptance Hints | Priority |
|----------|-------|-------------|------------------|----------|
| STORY-LESSON-001 | Draft Lesson | As an instructor I want to save a draft so that I can complete details later. | Status=Draft, not counted in progress. | High |
| STORY-LESSON-002 | Finalize Lesson | As an instructor I want to finalize a lesson so that progress updates. | Mandatory objectives present. | High |
| STORY-LESSON-003 | Prevent Delete Final | As the system I must disallow deletion of finalized lessons so that records remain authoritative. | 405/409 on delete attempt. | High |
| STORY-LESSON-004 | Amend Lesson | As an instructor I want to append corrections so that I can fix errors without altering history. | New record with amendedFromId. | Medium |
| STORY-LESSON-005 | Objective Assessment Validation | As the system I must validate objective assessments so that incomplete data isn't finalized. | 400 validation error list. | High |
| STORY-LESSON-006 | View Lesson History | As a student I want to view finalized lessons so that I can review progress. | Ordered list by date. | Medium |

## Risks / Mitigations
| Risk | Mitigation |
|------|------------|
| Overly complex form UX | Progressive disclosure of optional fields |
| Concurrency edits | Optimistic concurrency token (rowversion) |

## Dependencies
- Epic: Syllabus & Lesson Template Management (objective definitions)
- Epic: Identity & Authorization

## Definition of Done
- Draft → Finalize workflow complete
- Amend flow creates immutable lineage
- Validation errors structured (field + code)
- Domain service unit tests (objective rules)
