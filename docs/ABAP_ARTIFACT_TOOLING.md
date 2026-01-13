# ABAP artifact tooling (local)

This repo includes a small Python utility to fetch ABAP artifacts from an ABAP system URL without committing credentials into Git.

## Why this exists
Some ABAP artifacts relevant for PTF development (BDEF/CDS/DDIC) may not be present in the current abapGit scope, or may live in other systems. For syntax-accurate work (especially RAP/EML), it is useful to retrieve authoritative sources from the ABAP system on demand.

## Tool location
- `tools/abap_artifacts/`
- Entry point: `python -m abap_artifacts`

## Credential model
- Credentials must be provided by the user via environment variables or OS keychain (`keyring`).
- The repo contains no credentials and ignores `.env` by default (`.gitignore`).

See `tools/abap_artifacts/README.md` for setup and commands.

## Typical system/client references
For consistent examples, see `docs/SYSTEM_CLIENTS.md`.

## Common ADT URL patterns
See `docs/ABAP_ADT_URL_PATTERNS.md` for the URL patterns (classes, includes, etc.) that this tooling targets.

## Intended future direction (optional)
If you later add an MCP server, this tool can be used as a safe backend:
- MCP server runs locally on the user machine.
- It reads credentials from keyring/env.
- It exposes *read-only* calls like “get BDEF source”, returning only the artifact content.

This repo also includes a minimal MCP server wrapper:
- `tools/abap_artifacts_mcp/README.md`
