# Epic: Identity & Authorization

Epic ID: EPIC-IDENTITY-AUTHZ
Labels: epic, security, auth
Related Requirements: F-001, F-002, F-003, F-004, F-005, NFR (Security, Auditability)

## Goal
Provide secure authentication and robust role-based authorization so that each persona only accesses permitted data and actions, with full auditability of identity events.

## Success Metrics
- 100% protected API endpoints require valid bearer token.
- Unauthorized cross-student data access attempts blocked (zero successful IDOR incidents).
- Authentication events present in audit log within 2s.

## User Stories
| Story ID | Title | Description | Acceptance Hints | Priority |
|----------|-------|-------------|------------------|----------|
| STORY-AUTH-001 | Entra ID Login | As a user I want to sign in using organization / B2C identity so that I can access the system securely. | Token validation, role claim present. | High |
| STORY-AUTH-002 | Role Assignment | As an admin I want to assign or remove roles from a user so that I can control access. | Audit log entry, multiple roles union. | High |
| STORY-AUTH-003 | Student Data Isolation | As a student I want to only see my own records so that my privacy is preserved. | 403 on foreign student ID. | High |
| STORY-AUTH-004 | Auth Event Logging | As an auditor I want to view auth success/failure events so that I can detect anomalies. | Filter audit by actionType=AUTH_* . | Medium |
| STORY-AUTH-005 | Deactivate User | As an admin I want to deactivate a user so that access is removed without deleting history. | Login blocked after status=Inactive. | Medium |

## Out of Scope (This Epic)
- Self-service password reset (handled by Entra native UI)
- Multi-tenant partitioning (future epic)

## Risks / Mitigations
| Risk | Mitigation |
|------|------------|
| Over-permissioned admin role | Define principle of least privilege & review roles quarterly |
| Role claim drift vs DB | Real-time role resolution service or short cache TTL |

## Dependencies
- Epic: Audit & Compliance Logging (shared model)  
- Epic: Platform Infrastructure (Key Vault, App Service configuration)  

## Definition of Done
- All stories completed & merged
- Security tests (role matrix) passing
- Audit log showing sample events for login success/failure & role change
- Documentation updated in `docs/security.md`
