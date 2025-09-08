# Epic: Platform Infrastructure & DevOps

Epic ID: EPIC-PLATFORM-INFRA
Labels: epic, devops, infrastructure
Related Requirements: Architecture Section 9, NFR (Availability, Security, Observability, DR)

## Goal
Establish a secure, automated, observable Azure platform foundation enabling rapid, reliable deployments and operations.

## Success Metrics
- CI pipeline median time < 10m.
- Zero plaintext secrets in repository.
- Deployment rollback time < 10m.

## User Stories
| Story ID | Title | Description | Acceptance Hints | Priority |
|----------|-------|-------------|------------------|----------|
| STORY-INFRA-001 | Bicep Baseline | As a dev I want infra as code so that environments are reproducible. | `infra/main.bicep` provisions core resources. | High |
| STORY-INFRA-002 | Managed Identity Access | As the system I want managed identity for SQL so that secrets aren't stored. | DB connection w/out password. | High |
| STORY-INFRA-003 | App Insights & Logging | As an operator I want telemetry so that I can monitor health. | Requests, dependencies visible. | High |
| STORY-INFRA-004 | GitHub Actions Pipeline | As a dev I want automated build/test/deploy so that releases are consistent. | Workflow file with gates. | High |
| STORY-INFRA-005 | Key Vault Integration | As the system I want secrets externalized so that risk is reduced. | All secret refs resolved runtime. | High |
| STORY-INFRA-006 | Environment Promotion | As an admin I want staged environments so that changes are validated pre-prod. | Dev→QA→Prod workflow docs. | Medium |
| STORY-INFRA-007 | Backup & Restore Runbook | As an operator I want documented restore steps so that I can recover from failure. | Runbook in docs/. | Medium |

## Risks / Mitigations
| Risk | Mitigation |
|------|------------|
| Drift between envs | Automated IaC validation + periodic drift detection |
| Secrets sprawl | Central Key Vault + scanning tool in pipeline |

## Dependencies
- All service epics (runtime hosting)

## Definition of Done
- Bicep validated (what-if) and deployed to Dev
- Pipelines green (test + lint + security scan)
- Observability dashboards shared
