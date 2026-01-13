#!/bin/sh
set -eu

SRC="/home/petukhin/sdd/ptf/.vscode/settings.json"
DST="/home/petukhin/.vscode-server/data/User/mcp.json"

if [ ! -f "$SRC" ]; then
  echo "Missing $SRC"
  exit 1
fi

python3 - "$SRC" "$DST" <<'PY'
import json
import sys
from pathlib import Path

src = Path(sys.argv[1])
dst = Path(sys.argv[2])

data = json.loads(src.read_text(encoding="utf-8"))
servers = data.get("chat.mcp.servers")
if not isinstance(servers, dict):
    raise SystemExit("chat.mcp.servers not found in settings.json")

dst.parent.mkdir(parents=True, exist_ok=True)
dst.write_text(json.dumps({"servers": servers}, indent=2) + "\n", encoding="utf-8")
print(f"Synced MCP servers to {dst}")
PY
