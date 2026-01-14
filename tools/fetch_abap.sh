#!/bin/bash
# Helper script to run abap_artifacts CLI with proper environment

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"

export PYTHONPATH="$REPO_ROOT/tools/abap_artifacts:$REPO_ROOT/tools/abap_artifacts_mcp"
export ABAP_BASE_URL="${ABAP_BASE_URL:-https://ldai1emo.wdf.sap.corp:44300}"
export ABAP_CLIENT="${ABAP_CLIENT:-815}"
export ABAP_USER="${ABAP_USER:-PETUKHIN}"
export ABAP_KEYRING_BACKEND="${ABAP_KEYRING_BACKEND:-keyrings.alt.file.PlaintextKeyring}"
export PYTHON_KEYRING_BACKEND="${ABAP_KEYRING_BACKEND}"

# Run the CLI with all arguments passed through
python3 -m abap_artifacts "$@"
