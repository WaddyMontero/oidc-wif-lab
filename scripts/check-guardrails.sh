#!/usr/bin/env bash
set -euo pipefail

failures=0

fail() {
  echo "GUARDRAIL FAILURE: $1" >&2
  failures=$((failures + 1))
}

check_no_pattern() {
  local pattern="$1"
  local scope="$2"
  local message="$3"

  if rg -n --glob "$scope" "$pattern" . >/dev/null; then
    fail "$message"
  fi
}

check_required_pattern() {
  local pattern="$1"
  local file="$2"
  local message="$3"

  if ! rg -n "$pattern" "$file" >/dev/null; then
    fail "$message"
  fi
}

check_no_pattern_in_tf() {
  local pattern="$1"
  local path="$2"
  local message="$3"

  if rg -n -g '*.tf' "$pattern" "$path" >/dev/null; then
    fail "$message"
  fi
}

check_no_pattern_in_paths() {
  local pattern="$1"
  local message="$2"
  shift 2

  if rg -n --glob '!scripts/check-guardrails.sh' "$pattern" "$@" >/dev/null; then
    fail "$message"
  fi
}

# These checks are intentionally simple and string-based. That makes them easy
# for students to read, but it also means they are not a complete policy engine.
check_no_pattern_in_tf 'roles/owner' 'infra' 'Do not grant roles/owner in Terraform.'
check_no_pattern_in_tf 'roles/editor' 'infra' 'Do not grant roles/editor in Terraform.'
check_no_pattern_in_tf 'google_service_account_key' 'infra' 'Do not create service account keys.'
check_no_pattern_in_paths 'gcloud auth activate-service-account' 'Do not authenticate with long-lived service account keys.' .github scripts app infra
check_no_pattern_in_paths 'GOOGLE_APPLICATION_CREDENTIALS=.*\.json' 'Do not point GOOGLE_APPLICATION_CREDENTIALS at a checked-in JSON key.' .github scripts app infra
check_no_pattern_in_tf 'principalSet://.*/\*' 'infra' 'Do not allow every principal in a pool to impersonate deployer service accounts.'
check_no_pattern_in_paths 'private_key' 'Do not hardcode long-lived credentials.' .github scripts app infra

if rg -n 'id-token:\s*write' .github/workflows/ci.yml >/dev/null; then
  fail 'CI workflow must not request id-token: write.'
fi

if rg -n 'pull_request:' .github/workflows/deploy-staging.yml .github/workflows/deploy-production.yml >/dev/null; then
  fail 'Deploy workflows must not trigger on pull_request.'
fi

for claim in repository repository_owner ref environment workflow_ref; do
  check_required_pattern "attribute\\.${claim}" infra/modules/github-wif/main.tf "WIF provider condition must mention ${claim}."
done

if ((failures > 0)); then
  echo
  echo "Guardrail script found ${failures} issue(s)."
  echo "This script is a teaching aid, so treat passes as helpful signals rather than formal proof."
  exit 1
fi

echo "Guardrail checks passed."
