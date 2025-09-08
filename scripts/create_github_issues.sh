#!/usr/bin/env bash
set -euo pipefail

REPO="jspoelstra/hve-test"
DRY_RUN=${DRY_RUN:-false}

# --- Preflight -------------------------------------------------------------
# Provide clearer error messages & allow a "true" dry run that does *not*
# require the GitHub CLI to be installed/authenticated.
require_or_warn() {
  local missing=()
  for bin in "$@"; do
    command -v "$bin" >/dev/null 2>&1 || missing+=("$bin")
  done
  if ((${#missing[@]})); then
    echo "[WARN] Missing required tool(s): ${missing[*]}" >&2
    return 1
  fi
  return 0
}

preflight() {
  if [[ "$DRY_RUN" == "true" ]]; then
    # In a dry run we do *not* require gh; we just simulate.
    echo "[INFO] DRY_RUN enabled: skipping GitHub CLI presence/auth checks."
    return 0
  fi
  require_or_warn gh || { echo "[ERROR] GitHub CLI (gh) is required when DRY_RUN=false"; exit 1; }
  if ! gh auth status >/dev/null 2>&1; then
    echo "[ERROR] gh is not authenticated. Run: gh auth login" >&2
    exit 1
  fi
}

# --- Labels ----------------------------------------------------------------
# Ensure required labels exist. Provide color & short description. Colors are
# 6-char hex codes (no leading #) as expected by gh CLI.
ensure_label() {
  local name="$1"; shift
  local color="$1"; shift
  local desc="$1"; shift

  if [[ "$DRY_RUN" == "true" ]]; then
    echo "[DRY] ensure label: $name ($color) - $desc"
    return 0
  fi

  # Check existence
  if gh label list --repo "$REPO" --limit 500 --json name --jq ".[].name" | grep -Fxq "$name"; then
    return 0
  fi

  echo "[INFO] Creating missing label: $name"
  if ! gh label create "$name" --repo "$REPO" --color "$color" --description "$desc" 2>/dev/null; then
    # Race condition or already exists (another parallel run) -> ignore if now present
    if gh label list --repo "$REPO" --limit 500 --json name --jq ".[].name" | grep -Fxq "$name"; then
      return 0
    fi
    echo "[WARN] Failed to create label $name" >&2
  fi
}

ensure_labels() {
  echo "Ensuring required labels exist..."
  ensure_label epic        FF8C00 "High-level epic grouping"
  ensure_label story       0366D6 "Deliverable user story"
  ensure_label auth        5319E7 "Authentication & authorization"
  ensure_label security    D93F0B "Security related work"
  ensure_label audit       7057FF "Audit & compliance"
  ensure_label syllabus    0E8A16 "Syllabus / curriculum"
  ensure_label lessons     1D76DB "Lesson recording / updates"
  ensure_label stage-checks FBCA04 "Stage evaluations"
  ensure_label endorsements A1A1A1 "Endorsements features"
  ensure_label reporting   5319E7 "Reporting & metrics"
  ensure_label exports     0E8A16 "Data exports"
  ensure_label notifications C2E0C6 "Notification flow"
  ensure_label infra       0052CC "Platform & infra"
  ensure_label observability 5319E7 "Logging / metrics / traces"
  ensure_label devops      0366D6 "CI/CD & automation"
  ensure_label dr          D93F0B "Disaster recovery"
  ensure_label validation  FBCA04 "Validation logic"
}

# Create an issue if one with the exact title does not already exist.
create_issue() {
  local title="$1"; shift
  local body="$1"; shift
  local labels_csv="$1"; shift

  echo "Processing: $title"

  local existing=""
  if [[ "$DRY_RUN" != "true" ]]; then
    # Use env var for safe jq comparison (handles quotes/spaces)
    TITLE="$title" existing="$(gh issue list \
        --repo "$REPO" \
        --search "$title in:title" \
        --state all \
        --limit 100 \
        --json title \
        --jq '.[] | select(.title==env.TITLE) | .title' || true)"

    if [[ -n "$existing" ]]; then
      echo "  -> Exists, skipping"
      return 0
    fi
  fi

  # Build label args (split on commas)
  local label_args=()
  if [[ -n "${labels_csv// /}" ]]; then
    IFS=',' read -r -a _labels <<< "$labels_csv"
    for lbl in "${_labels[@]}"; do
      lbl_trimmed="$(echo "$lbl" | xargs)"
      [[ -z "$lbl_trimmed" ]] && continue
      label_args+=(--label "$lbl_trimmed")
    done
  fi

  if [[ "$DRY_RUN" == "true" ]]; then
    echo "  -> DRY RUN create (labels: ${labels_csv:-<none>})"
    return 0
  fi

  gh issue create \
    --repo "$REPO" \
    --title "$title" \
    --body "$body" \
    "${label_args[@]}" >/dev/null

  echo "  -> Created"
}

add_epics() {
  # Format: EPIC_ID:Epic Title
  while IFS=':' read -r epic_id epic_title; do
    [[ -z "$epic_id" ]] && continue
    local title="${epic_id}: ${epic_title}"
    local body
    body=$(cat <<EOF
(Imported) See backlog/epics/${epic_id}.md for full context.

This issue represents the epic ${epic_id}. Link child stories using "tracked by" or project board relationships.

Definition of Done (Epic):
- All scoped stories closed
- No critical open bugs
- Metrics / success criteria captured (if applicable)
EOF
)
    create_issue "$title" "$body" "epic"
  done <<'EOF'
EPIC-IDENTITY-AUTHZ:Identity & Authorization
EPIC-SYLLABUS-MGMT:Syllabus & Lesson Template Management
EPIC-LESSON-RECORDING:Lesson Recording & Amendments
EPIC-STAGE-CHECKS:Stage Checks & Evaluations
EPIC-ENDORSEMENTS:Endorsements & Regulatory Items
EPIC-REPORTING-EXPORTS:Reporting & Exports
EPIC-AUDIT-COMPLIANCE:Audit & Compliance Logging
EPIC-NOTIFICATIONS:Notifications & Alerts (MVP)
EPIC-PLATFORM-INFRA:Platform Infrastructure & DevOps
EOF
}

add_stories() {
  # Format:
  # STORY_ID|EPIC_ID|Title|Description (single line)|<unused>|labels(comma-separated)
  local entry
  while IFS='|' read -r sid epic title desc _ labels; do
    [[ -z "$sid" ]] && continue
    local issue_title="$sid: $title"
    local body
    body=$(cat <<EOF
$desc

Epic: $epic
Source: backlog/epics/${epic}.md

Acceptance Notes:
- Reference functional requirements listed in description
- Provide test evidence (screenshots / API test) before closing

Traceability:
- Requirements: see IDs in description
- Epic linkage: $epic
EOF
)
    create_issue "$issue_title" "$body" "$labels"
  done <<'EOF'
STORY-AUTH-001|EPIC-IDENTITY-AUTHZ|User Login via Entra ID|Implements STORY-AUTH-001 (F-001, F-005). Accept: valid token yields 200 on /me.||story,auth
STORY-AUTH-002|EPIC-IDENTITY-AUTHZ|Admin Role Assignment|Implements STORY-AUTH-002 (F-002, F-004). Audit role changes.| |story,auth,security
STORY-AUTH-003|EPIC-IDENTITY-AUTHZ|Student Data Isolation|Implements STORY-AUTH-003 (F-003). 403 on foreign student id.| |story,auth,security
STORY-AUTH-004|EPIC-IDENTITY-AUTHZ|Auth Event Logging|Implements STORY-AUTH-004 (F-005). Log success/fail.| |story,audit
STORY-AUTH-005|EPIC-IDENTITY-AUTHZ|Deactivate User|Implements STORY-AUTH-005 (F-180). Block login after deactivation.| |story,auth
STORY-SYL-001|EPIC-SYLLABUS-MGMT|Create Syllabus Template|Implements STORY-SYL-001 (F-020).| |story,syllabus
STORY-SYL-002|EPIC-SYLLABUS-MGMT|Clone Syllabus Template|Implements STORY-SYL-002 (F-022).| |story,syllabus
STORY-SYL-003|EPIC-SYLLABUS-MGMT|Lock Active Syllabus Version|Implements STORY-SYL-003 (F-021).| |story,syllabus
STORY-SYL-004|EPIC-SYLLABUS-MGMT|Instantiate Student Syllabus|Implements STORY-SYL-004 (F-040).| |story,syllabus
STORY-SYL-005|EPIC-SYLLABUS-MGMT|Progress Calculation|Implements STORY-SYL-005 (F-042).| |story,syllabus
STORY-SYL-006|EPIC-SYLLABUS-MGMT|View Syllabus Structure|Implements STORY-SYL-006 (F-020).| |story,syllabus
STORY-LESSON-001|EPIC-LESSON-RECORDING|Draft Lesson Record|Implements STORY-LESSON-001 (F-060).| |story,lessons
STORY-LESSON-002|EPIC-LESSON-RECORDING|Finalize Lesson|Implements STORY-LESSON-002 (F-061).| |story,lessons
STORY-LESSON-003|EPIC-LESSON-RECORDING|Prevent Finalized Delete|Implements STORY-LESSON-003 (F-062).| |story,lessons,security
STORY-LESSON-004|EPIC-LESSON-RECORDING|Amend Lesson Record|Implements STORY-LESSON-004 (F-063).| |story,lessons,audit
STORY-LESSON-005|EPIC-LESSON-RECORDING|Objective Assessment Validation|Implements STORY-LESSON-005 (F-061).| |story,lessons,validation
STORY-LESSON-006|EPIC-LESSON-RECORDING|View Lesson History|Implements STORY-LESSON-006 (F-060).| |story,lessons
STORY-STAGE-001|EPIC-STAGE-CHECKS|Create Stage Check|Implements STORY-STAGE-001 (F-080).| |story,stage-checks
STORY-STAGE-002|EPIC-STAGE-CHECKS|Record Evaluation Outcome|Implements STORY-STAGE-002 (F-080,F-081).| |story,stage-checks
STORY-STAGE-003|EPIC-STAGE-CHECKS|Require Remediation Tasks|Implements STORY-STAGE-003 (F-081).| |story,stage-checks,validation
STORY-STAGE-004|EPIC-STAGE-CHECKS|Sign Off Evaluation|Implements STORY-STAGE-004 (F-082).| |story,stage-checks,audit
STORY-STAGE-005|EPIC-STAGE-CHECKS|View Stage Evaluation|Implements STORY-STAGE-005 (F-080).| |story,stage-checks
STORY-END-001|EPIC-ENDORSEMENTS|List Endorsement Templates|Implements STORY-END-001 (F-100).| |story,endorsements
STORY-END-002|EPIC-ENDORSEMENTS|Issue Endorsement|Implements STORY-END-002 (F-100,F-101).| |story,endorsements,security
STORY-END-003|EPIC-ENDORSEMENTS|View Student Endorsements|Implements STORY-END-003 (F-102).| |story,endorsements
STORY-END-004|EPIC-ENDORSEMENTS|Endorsement Integrity Check|Implements STORY-END-004 (F-101).| |story,endorsements,audit
STORY-RPT-001|EPIC-REPORTING-EXPORTS|Export Student Record|Implements STORY-RPT-001 (F-120, AC-05).| |story,reporting,exports
STORY-RPT-002|EPIC-REPORTING-EXPORTS|Async Large Export|Implements STORY-RPT-002 (F-120).| |story,reporting,exports
STORY-RPT-003|EPIC-REPORTING-EXPORTS|Metrics Dashboard Data API|Implements STORY-RPT-003 (F-121).| |story,reporting
STORY-RPT-004|EPIC-REPORTING-EXPORTS|Filtered Reports|Implements STORY-RPT-004 (F-121).| |story,reporting
STORY-AUD-001|EPIC-AUDIT-COMPLIANCE|Log Mutations|Implements STORY-AUD-001 (F-160).| |story,audit
STORY-AUD-002|EPIC-AUDIT-COMPLIANCE|Log Auth Events|Implements STORY-AUD-002 (F-160,F-161).| |story,audit,security
STORY-AUD-003|EPIC-AUDIT-COMPLIANCE|Query Audit Logs|Implements STORY-AUD-003 (F-161).| |story,audit
STORY-AUD-004|EPIC-AUDIT-COMPLIANCE|Export Audit CSV|Implements STORY-AUD-004 (F-162).| |story,audit,exports
STORY-NOTIF-001|EPIC-NOTIFICATIONS|Stage Check Assignment Email|Implements STORY-NOTIF-001 (F-140).| |story,notifications
STORY-NOTIF-002|EPIC-NOTIFICATIONS|Stage Check Result Email|Implements STORY-NOTIF-002 (F-141).| |story,notifications
STORY-NOTIF-003|EPIC-NOTIFICATIONS|Stale Draft Reminder|Implements STORY-NOTIF-003 (F-142).| |story,notifications
STORY-INFRA-001|EPIC-PLATFORM-INFRA|Bicep Infrastructure Baseline|Implements STORY-INFRA-001 (Arch Sec 9).| |story,infra,devops
STORY-INFRA-002|EPIC-PLATFORM-INFRA|Managed Identity for SQL|Implements STORY-INFRA-002 (Security).| |story,infra,security
STORY-INFRA-003|EPIC-PLATFORM-INFRA|App Insights & Logging|Implements STORY-INFRA-003 (Observability).| |story,infra,observability
STORY-INFRA-004|EPIC-PLATFORM-INFRA|CI/CD Pipeline|Implements STORY-INFRA-004 (Deployment).| |story,infra,devops
STORY-INFRA-005|EPIC-PLATFORM-INFRA|Key Vault Integration|Implements STORY-INFRA-005 (Security).| |story,infra,security
STORY-INFRA-006|EPIC-PLATFORM-INFRA|Environment Promotion Workflow|Implements STORY-INFRA-006 (Release).| |story,infra,devops
STORY-INFRA-007|EPIC-PLATFORM-INFRA|Backup & Restore Runbook|Implements STORY-INFRA-007 (DR).| |story,infra,dr
EOF
}

main() {
  echo "Starting GitHub issue creation (DRY_RUN=$DRY_RUN)"
  preflight
  ensure_labels
  add_epics
  add_stories
  echo "Done."
}

main "$@"