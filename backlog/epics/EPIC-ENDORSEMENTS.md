# Epic: Endorsements & Regulatory Items

Epic ID: EPIC-ENDORSEMENTS
Labels: epic, compliance, endorsements
Related Requirements: F-100, F-101, F-102

## Goal
Provide a standardized, tamper-evident mechanism for issuing and tracking required regulatory endorsements to students.

## Success Metrics
- Endorsement issuance workflow < 45s median.
- 0 hash mismatches in periodic integrity verification job.
- Active vs expired status accurate at query time.

## User Stories
| Story ID | Title | Description | Acceptance Hints | Priority |
|----------|-------|-------------|------------------|----------|
| STORY-END-001 | List Templates | As an instructor I want to view endorsement templates so that I can choose the right one. | Returns list sorted by code. | Medium |
| STORY-END-002 | Issue Endorsement | As an instructor I want to issue an endorsement so that student has required authorization. | Hash stored & returned. | High |
| STORY-END-003 | View Student Endorsements | As a student I want to view my endorsements so that I know my current privileges. | Active/expired flags. | Medium |
| STORY-END-004 | Integrity Check | As the system I must verify endorsement hashes so that tampering is detectable. | Background job or on-read recompute. | Medium |

## Risks / Mitigations
| Risk | Mitigation |
|------|------------|
| Template legal ambiguity | Disclaimer & external legal review |
| Hash collision concerns | SHA-256 canonical JSON; include salt version field |

## Dependencies
- Epic: Identity & Authorization
- Epic: Audit & Compliance Logging

## Definition of Done
- Issue + list endpoints implemented
- Hash verification unit tests
- Documentation of canonicalization rules
