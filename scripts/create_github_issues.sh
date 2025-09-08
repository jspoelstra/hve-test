#!/usr/bin/env bash
set -euo pipefail

# Configuration
REPO="jspoelstra/hve-test"
DRY_RUN=${DRY_RUN:-false}

# Utility: create issue if not exists (search by title)
create_issue() {
  local title="$1"; shift
  local body="$1"; shift
  local labels="$1"; shift

  echo "Processing: $title"
  local existing
  existing=$(gh issue list --repo "$REPO" --search "$title in:title" --state all --json title --jq '.[] | select(.title=="'$title'") | .title' || true)
  if [[ -n "$existing" ]]; then
    echo "  -> Exists, skipping"
    return 0
  fi

  if [[ "$DRY_RUN" == "true" ]]; then
    echo "  -> DRY RUN create (labels: $labels)"
    return 0
  fi

  gh issue create --repo "$REPO" --title "$title" --body "$body" --label "$labels" >/dev/null
  echo "  -> Created"
}

# Read epic markdown tables to form issues manually (hard-coded structure for now)
# Epics definitions (title|file|labels)

add_epics() {
  declare -A EPICS
  EPICS["EPIC-IDENTITY-AUTHZ"]="Identity & Authorization"
  EPICS["EPIC-SYLLABUS-MGMT"]="Syllabus & Lesson Template Management"
  EPICS["EPIC-LESSON-RECORDING"]="Lesson Recording & Amendments"
  EPICS["EPIC-STAGE-CHECKS"]="Stage Checks & Evaluations"
  EPICS["EPIC-ENDORSEMENTS"]="Endorsements & Regulatory Items"
  EPICS["EPIC-REPORTING-EXPORTS"]="Reporting & Exports"
  EPICS["EPIC-AUDIT-COMPLIANCE"]="Audit & Compliance Logging"
  EPICS["EPIC-NOTIFICATIONS"]="Notifications & Alerts (MVP)"
  EPICS["EPIC-PLATFORM-INFRA"]="Platform Infrastructure & DevOps"

  for id in "${!EPICS[@]}"; do
    title="$id: ${EPICS[$id]}"
    body="(Imported) See backlog/epics/${id}.md for full context.\n\nThis issue tracks epic ${id}. Link child stories using 'tracked by' / project board."
    create_issue "$title" "$body" "epic"
  done
}

add_stories() {
  # Each story: ID|Epic|Title|Body ref|Labels
  stories=(
    "STORY-AUTH-001|EPIC-IDENTITY-AUTHZ|User Login via Entra ID|Implements STORY-AUTH-001 (F-001, F-005). Accept: valid token yields 200 on /me.||story,auth"
    "STORY-AUTH-002|EPIC-IDENTITY-AUTHZ|Admin Role Assignment|Implements STORY-AUTH-002 (F-002, F-004). Audit role changes.| |story,auth,security"
    "STORY-AUTH-003|EPIC-IDENTITY-AUTHZ|Student Data Isolation|Implements STORY-AUTH-003 (F-003). 403 on foreign student id.| |story,auth,security"
    "STORY-AUTH-004|EPIC-IDENTITY-AUTHZ|Auth Event Logging|Implements STORY-AUTH-004 (F-005). Log success/fail.| |story,audit"
    "STORY-AUTH-005|EPIC-IDENTITY-AUTHZ|Deactivate User|Implements STORY-AUTH-005 (F-180). Block login after deactivation.| |story,auth"

    "STORY-SYL-001|EPIC-SYLLABUS-MGMT|Create Syllabus Template|Implements STORY-SYL-001 (F-020).| |story,syllabus"
    "STORY-SYL-002|EPIC-SYLLABUS-MGMT|Clone Syllabus Template|Implements STORY-SYL-002 (F-022).| |story,syllabus"
    "STORY-SYL-003|EPIC-SYLLABUS-MGMT|Lock Active Syllabus Version|Implements STORY-SYL-003 (F-021).| |story,syllabus"
    "STORY-SYL-004|EPIC-SYLLABUS-MGMT|Instantiate Student Syllabus|Implements STORY-SYL-004 (F-040).| |story,syllabus"
    "STORY-SYL-005|EPIC-SYLLABUS-MGMT|Progress Calculation|Implements STORY-SYL-005 (F-042).| |story,syllabus"
    "STORY-SYL-006|EPIC-SYLLABUS-MGMT|View Syllabus Structure|Implements STORY-SYL-006 (F-020).| |story,syllabus"

    "STORY-LESSON-001|EPIC-LESSON-RECORDING|Draft Lesson Record|Implements STORY-LESSON-001 (F-060).| |story,lessons"
    "STORY-LESSON-002|EPIC-LESSON-RECORDING|Finalize Lesson|Implements STORY-LESSON-002 (F-061).| |story,lessons"
    "STORY-LESSON-003|EPIC-LESSON-RECORDING|Prevent Finalized Delete|Implements STORY-LESSON-003 (F-062).| |story,lessons,security"
    "STORY-LESSON-004|EPIC-LESSON-RECORDING|Amend Lesson Record|Implements STORY-LESSON-004 (F-063).| |story,lessons,audit"
    "STORY-LESSON-005|EPIC-LESSON-RECORDING|Objective Assessment Validation|Implements STORY-LESSON-005 (F-061).| |story,lessons,validation"
    "STORY-LESSON-006|EPIC-LESSON-RECORDING|View Lesson History|Implements STORY-LESSON-006 (F-060).| |story,lessons"

    "STORY-STAGE-001|EPIC-STAGE-CHECKS|Create Stage Check|Implements STORY-STAGE-001 (F-080).| |story,stage-checks"
    "STORY-STAGE-002|EPIC-STAGE-CHECKS|Record Evaluation Outcome|Implements STORY-STAGE-002 (F-080,F-081).| |story,stage-checks"
    "STORY-STAGE-003|EPIC-STAGE-CHECKS|Require Remediation Tasks|Implements STORY-STAGE-003 (F-081).| |story,stage-checks,validation"
    "STORY-STAGE-004|EPIC-STAGE-CHECKS|Sign Off Evaluation|Implements STORY-STAGE-004 (F-082).| |story,stage-checks,audit"
    "STORY-STAGE-005|EPIC-STAGE-CHECKS|View Stage Evaluation|Implements STORY-STAGE-005 (F-080).| |story,stage-checks"

    "STORY-END-001|EPIC-ENDORSEMENTS|List Endorsement Templates|Implements STORY-END-001 (F-100).| |story,endorsements"
    "STORY-END-002|EPIC-ENDORSEMENTS|Issue Endorsement|Implements STORY-END-002 (F-100,F-101).| |story,endorsements,security"
    "STORY-END-003|EPIC-ENDORSEMENTS|View Student Endorsements|Implements STORY-END-003 (F-102).| |story,endorsements"
    "STORY-END-004|EPIC-ENDORSEMENTS|Endorsement Integrity Check|Implements STORY-END-004 (F-101).| |story,endorsements,audit"

    "STORY-RPT-001|EPIC-REPORTING-EXPORTS|Export Student Record|Implements STORY-RPT-001 (F-120, AC-05).| |story,reporting,exports"
    "STORY-RPT-002|EPIC-REPORTING-EXPORTS|Async Large Export|Implements STORY-RPT-002 (F-120).| |story,reporting,exports"
    "STORY-RPT-003|EPIC-REPORTING-EXPORTS|Metrics Dashboard Data API|Implements STORY-RPT-003 (F-121).| |story,reporting"
    "STORY-RPT-004|EPIC-REPORTING-EXPORTS|Filtered Reports|Implements STORY-RPT-004 (F-121).| |story,reporting"

    "STORY-AUD-001|EPIC-AUDIT-COMPLIANCE|Log Mutations|Implements STORY-AUD-001 (F-160).| |story,audit"
    "STORY-AUD-002|EPIC-AUDIT-COMPLIANCE|Log Auth Events|Implements STORY-AUD-002 (F-160,F-161).| |story,audit,security"
    "STORY-AUD-003|EPIC-AUDIT-COMPLIANCE|Query Audit Logs|Implements STORY-AUD-003 (F-161).| |story,audit"
    "STORY-AUD-004|EPIC-AUDIT-COMPLIANCE|Export Audit CSV|Implements STORY-AUD-004 (F-162).| |story,audit,exports"

    "STORY-NOTIF-001|EPIC-NOTIFICATIONS|Stage Check Assignment Email|Implements STORY-NOTIF-001 (F-140).| |story,notifications"
    "STORY-NOTIF-002|EPIC-NOTIFICATIONS|Stage Check Result Email|Implements STORY-NOTIF-002 (F-141).| |story,notifications"
    "STORY-NOTIF-003|EPIC-NOTIFICATIONS|Stale Draft Reminder|Implements STORY-NOTIF-003 (F-142).| |story,notifications"

    "STORY-INFRA-001|EPIC-PLATFORM-INFRA|Bicep Infrastructure Baseline|Implements STORY-INFRA-001 (Arch Sec 9).| |story,infra,devops"
    "STORY-INFRA-002|EPIC-PLATFORM-INFRA|Managed Identity for SQL|Implements STORY-INFRA-002 (Security).| |story,infra,security"
    "STORY-INFRA-003|EPIC-PLATFORM-INFRA|App Insights & Logging|Implements STORY-INFRA-003 (Observability).| |story,infra,observability"
    "STORY-INFRA-004|EPIC-PLATFORM-INFRA|CI/CD Pipeline|Implements STORY-INFRA-004 (Deployment).| |story,infra,devops"
    "STORY-INFRA-005|EPIC-PLATFORM-INFRA|Key Vault Integration|Implements STORY-INFRA-005 (Security).| |story,infra,security"
    "STORY-INFRA-006|EPIC-PLATFORM-INFRA|Environment Promotion Workflow|Implements STORY-INFRA-006 (Release).| |story,infra,devops"
    "STORY-INFRA-007|EPIC-PLATFORM-INFRA|Backup & Restore Runbook|Implements STORY-INFRA-007 (DR).| |story,infra,dr"
  )

  for entry in "${stories[@]}"; do
    IFS='|' read -r sid epic title desc _ labels <<< "$entry"
    issue_title="$sid: $title"
    body="${desc}\n\nEpic: $epic\nSource: backlog/epics/${epic}.md"
    create_issue "$issue_title" "$body" "$labels"
  done
}

main() {
  echo "Starting GitHub issue creation (DRY_RUN=$DRY_RUN)"
  add_epics
  add_stories
  echo "Done." 
}

main "$@"
