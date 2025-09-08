# Epic: Syllabus & Lesson Template Management

Epic ID: EPIC-SYLLABUS-MGMT
Labels: epic, syllabus, curriculum
Related Requirements: F-020, F-021, F-022, F-023, F-040, F-041, F-042

## Goal
Enable admins to define, version, and manage structured training syllabi and instantiate individualized plans for students without disrupting active progress.

## Success Metrics
- New syllabus version creation < 2 minutes workflow.
- Zero unintended retroactive changes to existing student syllabi after version publish.
- Progress calculation accuracy ≥ 99% vs manual verification sample.

## User Stories
| Story ID | Title | Description | Acceptance Hints | Priority |
|----------|-------|-------------|------------------|----------|
| STORY-SYL-001 | Create Template | As an admin I want to create a syllabus template so that I can standardize training. | Ordered stages/lessons persisted. | High |
| STORY-SYL-002 | Clone Template | As an admin I want to clone a template version so that I can iterate safely. | New version number, reference to prior. | Medium |
| STORY-SYL-003 | Lock Active Version | As the system I must lock a template in use so that in-progress students aren't affected. | Edit attempt blocked with error. | High |
| STORY-SYL-004 | Instantiate Student Syllabus | As an admin I want to enroll a student into a rating so that individualized lesson instances are created. | Lessons appear with status=Assigned. | High |
| STORY-SYL-005 | Progress Calculation | As a student I want to see my completion percent so that I understand progress. | Completed / total lessons rounding rule documented. | High |
| STORY-SYL-006 | View Syllabus Structure | As an instructor I want to view syllabus hierarchy so that I can plan instruction. | API returns stages/lessons list. | Medium |

## Risks / Mitigations
| Risk | Mitigation |
|------|------------|
| Version explosion | Enforce description + change log on publish |
| Incorrect progress math | Dedicated domain service + unit tests |

## Dependencies
- Epic: Identity & Authorization (permissions)  
- Epic: Lesson Recording (consumes lesson instances)  

## Definition of Done
- CRUD + clone endpoints implemented
- Version immutability enforced
- Progress service unit tested (edge: zero lessons)
- API docs updated
