#!/usr/bin/env bash
#
# Verify an installed Cask: every app artifact it declares must be present in
# /Applications, and — for Casks that strip com.apple.quarantine during install
# — no file inside those apps may still carry the quarantine attribute.
#
# Usage: verify-cask.sh <user/tap/cask> <path/to/Casks/cask.rb>

set -euo pipefail

readonly CASK_TOKEN="${1:?usage: verify-cask.sh <cask token> <cask file>}"
readonly CASK_FILE="${2:?usage: verify-cask.sh <cask token> <cask file>}"

err() {
  echo "::error::$*" >&2
}

# Fails the run if anything under the app bundle is still quarantined. Gatekeeper
# blocks an unsigned app on the first quarantined file it finds, so the check has
# to be recursive rather than just the bundle root.
check_quarantine() {
  local app_path="$1"
  local quarantined
  # `xattr -r -p` exits non-zero for every file lacking the attribute, so the
  # output, not the exit status, is what says whether anything is quarantined.
  quarantined="$(xattr -r -p com.apple.quarantine "${app_path}" 2>/dev/null || true)"
  if [[ -n "${quarantined}" ]]; then
    err "com.apple.quarantine still present after install:"
    echo "${quarantined}" >&2
    return 1
  fi
  echo "  no com.apple.quarantine attribute remains"
}

main() {
  local apps
  apps="$(brew info --cask --json=v2 "${CASK_TOKEN}" | jq -r '.casks[0].artifacts[]?.app[]?')"

  if [[ -z "${apps}" ]]; then
    err "${CASK_TOKEN} declares no app artifact; nothing to verify"
    exit 1
  fi

  # Only Casks that promise to strip quarantine are held to that promise.
  local expects_no_quarantine=0
  if grep -q "com.apple.quarantine" "${CASK_FILE}"; then
    expects_no_quarantine=1
  fi

  local app app_path
  while IFS= read -r app; do
    app_path="/Applications/${app}"
    if [[ ! -d "${app_path}" ]]; then
      err "${app_path} does not exist after install"
      exit 1
    fi
    echo "${app_path} installed"

    if ((expects_no_quarantine)); then
      check_quarantine "${app_path}"
    fi
  done <<< "${apps}"
}

main "$@"
