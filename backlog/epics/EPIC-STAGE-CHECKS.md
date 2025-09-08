# Epic: Stage Checks & Evaluations

Epic ID: EPIC-STAGE-CHECKS
Labels: epic, evaluation, quality
Related Requirements: F-080, F-081, F-082

## Goal
Support structured milestone evaluations that gate progression between syllabus stages, ensuring training quality and regulatory compliance.

## Success Metrics
- 100% of stage transitions validated via stage check pass.
- Remediation tasks captured for all Conditional/Fail outcomes.
- Student visibility of evaluation within < 10s of sign-off.

## User Stories
| Story ID | Title | Description | Acceptance Hints | Priority |
|----------|-------|-------------|------------------|----------|
| STORY-STAGE-001 | Create Stage Check | As an instructor (scheduler) I want to create a stage check record so that an evaluator can perform it. | Pending state. | High |
| STORY-STAGE-002 | Record Evaluation Outcome | As a stage-check instructor I want to record pass/conditional/fail so that student status updates. | Outcome rules enforced. | High |
| STORY-STAGE-003 | Require Remediation | As the system I must require remediation tasks when outcome not Pass so that deficiencies tracked. | Validation error if empty. | High |
| STORY-STAGE-004 | Sign Off Evaluation | As a stage-check instructor I want to sign the evaluation so that it becomes immutable. | signedAt timestamp set. | High |
| STORY-STAGE-005 | View Evaluation | As a student I want to view my evaluation so that I know next steps. | Read-only view. | Medium |

## Risks / Mitigations
| Risk | Mitigation |
|------|------------|
| Missing remediation follow-up | Link remediation tasks to flagged lessons queue |
| Premature stage completion | Only update progress service on Pass |

## Dependencies
- Epic: Syllabus & Lesson Template Management
- Epic: Identity & Authorization

## Definition of Done
- Outcome rules tested (Conditional/Fail requires tasks)
- Immutable after sign-off (append-only corrections)
- Audit events for creation and sign-off
