#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <steady|ramp-up|burst|spike-drop> [target_url]"
  exit 1
fi

SCENARIO="$1"
TARGET_URL="${2:-http://localhost:8000}"
SCRIPT_PATH="load-tests/${SCENARIO}.js"

if [[ ! -f "${SCRIPT_PATH}" ]]; then
  echo "Scenario not found: ${SCRIPT_PATH}"
  exit 1
fi

echo "Run scenario=${SCENARIO}, target=${TARGET_URL}"
TARGET_BASE_URL="${TARGET_URL}" k6 run "${SCRIPT_PATH}"
