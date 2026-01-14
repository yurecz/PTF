#!/bin/sh
set -eu

ROOT_DIR=$(cd "$(dirname "$0")/.." && pwd)

export PYTHON_KEYRING_BACKEND="keyrings.alt.file.PlaintextKeyring"
export PYTHONPATH="$ROOT_DIR/tools/abap_artifacts"

base_url=${ABAP_BASE_URL:-}
client=${ABAP_CLIENT:-}
user=${ABAP_USER:-}
prev=
for arg in "$@"; do
  if [ -n "$prev" ]; then
    case "$prev" in
      base_url) base_url=$arg ;;
      client) client=$arg ;;
      user) user=$arg ;;
    esac
    prev=
    continue
  fi
  case "$arg" in
    --base-url) prev=base_url ;;
    --client) prev=client ;;
    --user) prev=user ;;
  esac
done

if [ "${ABAP_CLI_USE_ENV:-}" != "1" ] && [ -n "$base_url" ] && [ -n "$client" ] && [ -n "$user" ]; then
  export ABAP_BASE_URL="$base_url"
  export ABAP_CLIENT="$client"
  export ABAP_USER="$user"
  ABAP_PASSWORD="$(python3 - <<'PY'
import os
import keyring

base_url = os.environ.get("ABAP_BASE_URL", "").rstrip("/")
client = os.environ.get("ABAP_CLIENT", "")
user = os.environ.get("ABAP_USER", "")

service = f"abap_artifacts::{base_url}::client::{client}"
password = keyring.get_password(service, user)
if not password:
    password = keyring.get_password(base_url, user)
print(password or "")
PY
)"
  export ABAP_PASSWORD
fi

if [ "${ABAP_CLI_DEBUG:-}" = "1" ]; then
  printf '%s\n' "ABAP_PASSWORD length: ${#ABAP_PASSWORD}"
fi

exec python3 -m abap_artifacts "$@"
