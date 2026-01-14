# MCP Setup (abap-artifacts)

This repo uses an MCP server for ABAP artifact access. VS Code launches it via `.vscode/abap_mcp.sh`.

## Current wiring

- VS Code setting: `.vscode/settings.json`
  - `chat.mcp.servers.abap-artifacts.command` -> `/home/petukhin/sdd/ptf/.vscode/abap_mcp.sh`
- MCP launch script: `.vscode/abap_mcp.sh`
  - Exports ABAP connection env vars and runs `python3 -m abap_artifacts_mcp`.
- Sync tool: `tools/sync_mcp_config.sh`
  - Copies the repo MCP config into `~/.vscode-server/data/User/mcp.json`.

## Environment variables (from `.vscode/abap_mcp.sh`)

- `ABAP_BASE_URL` (example: `https://ldai1emo.wdf.sap.corp:44300`)
- `ABAP_CLIENT` (example: `815`)
- `ABAP_USER` (example: `PETUKHIN`)
- `ABAP_PASSWORD` (optional; if unset, keyring is used)
- `ABAP_KEYRING_BACKEND` (example: `keyrings.alt.file.PlaintextKeyring`)
- `PYTHON_KEYRING_BACKEND` (same as `ABAP_KEYRING_BACKEND`)
- `PYTHONPATH` (points at `tools/abap_artifacts` and `tools/abap_artifacts_mcp`)

The script also ensures:
- `XDG_RUNTIME_DIR` exists.
- `DBUS_SESSION_BUS_ADDRESS` is set via `dbus-launch` when available.

## Logs

- MCP log file: `.vscode/abap_mcp.log`
- Codex extension log (WSL): `~/.vscode-server/data/logs/<timestamp>/exthost*/openai.chatgpt/Codex.log`

## Troubleshooting checklist

1) Confirm the server command in `.vscode/settings.json` points to `.vscode/abap_mcp.sh`.
2) Run `tools/sync_mcp_config.sh` after changing MCP settings.
3) Inspect `.vscode/abap_mcp.log` for environment details and errors.
4) Verify credentials:
   - Set `ABAP_PASSWORD` in the environment, or
   - Ensure the keyring backend can read stored credentials.
5) If DBus or runtime dir issues appear, verify the script created `XDG_RUNTIME_DIR` and started a DBus session.

## First steps for new Codex sessions

1) Read `AGENTS.md` and this document.
2) Run `tools/sync_mcp_config.sh`.
3) Re-read `AGENTS.md` and `docs/MCP_SETUP.md` in the session.
4) Use the `abap-artifacts` MCP server instead of asking for `ABAP_BASE_URL`.
5) If MCP is still unavailable, restart the Codex extension or reload the VS Code window.

## Notes

- The MCP server is meant for VS Code features/extensions that support MCP integration.
- **Copilot Chat cannot access MCP** in this environment; **Codex can** when configured via the wrapper script and MCP sync.
- If a new Codex session cannot access MCP, the usual fix is to re-sync MCP settings and restart the extension.
