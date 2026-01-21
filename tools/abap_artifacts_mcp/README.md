# ABAP artifacts MCP server (local)

This is a minimal **MCP (Model Context Protocol)** server that exposes **read-only** tools for fetching ABAP artifacts from ADT/ICF endpoints, while keeping credentials in your local environment (env vars / OS keychain).

It wraps the fetch logic in `tools/abap_artifacts/`.

## Security model
- No credentials are stored in this repo.
- The server reads credentials from environment variables and/or OS keychain (via `keyring` if installed).
- The server refuses to send credentials to a different origin than `ABAP_BASE_URL`.

## Prerequisites
- Python 3.10+
- For keychain support: `pip install keyring` (optional)

## Configure credentials (examples)
Recommended: keep these in your shell profile or secret manager:
- `ABAP_BASE_URL` (e.g. `https://ldai1emo.wdf.sap.corp:44300`)
- `ABAP_CLIENT` (e.g. `815`)
- `ABAP_USER`
- `ABAP_PASSWORD` (or store password via the `keyring` flow in `tools/abap_artifacts/README.md`)

## Run (stdio MCP)
From repo root:
- `PYTHONPATH=tools/abap_artifacts:tools/abap_artifacts_mcp python -m abap_artifacts_mcp`

## Tools exposed
- `abap.fetchDocu` (no auth): fetch ABAP Keyword Docu page by `object` id.
- `abap.fetchUrl` (optional auth): fetch any URL (auth only if requested and same-origin).
- `abap.fetchBdef`: fetch BDEF source via ADT.
- `abap.fetchCds`: fetch CDS DDL source via ADT.
- `abap.fetchClass`: fetch ABAP class main source via ADT.
- `abap.fetchClassInclude`: fetch ABAP class include via ADT.
- `abap.fetchInterface`: fetch ABAP interface source via ADT.
- `abap.fetchFunctionGroup`: fetch function group main source via ADT.
- `abap.fetchFunctionGroupInclude`: fetch function group include source via ADT.
- `abap.fetchFunctionModule`: fetch function module source via ADT.
- `abap.fetchTable`: fetch DDIC table source via ADT.
- `abap.fetchStructure`: fetch DDIC structure source via ADT.
- `abap.fetchDataElement`: fetch DDIC data element source via ADT.
- `abap.fetchDomain`: fetch DDIC domain source via ADT.
- `abap.checkSyntax`: check ABAP syntax via ADT parser API (returns syntax errors/warnings).

## MCP client configuration
Add this server to your MCP client (Codex / IDE integration) as a stdio server command that runs the module above.

Example command:
- `python -m abap_artifacts_mcp`

Example environment (recommended):
- `ABAP_BASE_URL`
- `ABAP_CLIENT`
- `ABAP_USER`
- `ABAP_PASSWORD` (or keychain via `keyring`)

Example stdio server definition (generic shape; adapt to your client’s schema):
```json
{
  "name": "abap-artifacts",
  "command": "python",
  "args": ["-m", "abap_artifacts_mcp"],
  "env": {
    "PYTHONPATH": "tools/abap_artifacts:tools/abap_artifacts_mcp",
    "ABAP_BASE_URL": "https://ldai1emo.wdf.sap.corp:44300",
    "ABAP_CLIENT": "815",
    "ABAP_USER": "YOUR_USER"
  }
}
```

Keep `ABAP_PASSWORD` out of config files if possible; prefer OS keychain.
