# ABAP artifact fetcher (local, credential-isolated)

This tool fetches ABAP artifacts (for example ADT sources like BDEF) from an ABAP system URL **without storing credentials in the Git repo**.

It is intended as a building block for an MCP server or other automation where:
- Credentials are managed by the user (environment variables or OS keychain).
- The caller (e.g., an LLM tool) receives only the retrieved artifact content.

## Install (local)
From repo root:
- `python3 -m venv .venv`
- `. .venv/bin/activate`
- `python -m pip install -e tools/abap_artifacts`

If you prefer not installing editable packages, you can run with:
- `PYTHONPATH=tools/abap_artifacts python -m abap_artifacts ...`

## Configure credentials (choose one)

### Option A: environment variables (simple)
Set these in your shell profile or a secret manager (do not commit them):
- `ABAP_BASE_URL` (e.g. `https://<host>:<port>`)
- `ABAP_CLIENT` (e.g. `030`)
- `ABAP_USER`
- `ABAP_PASSWORD`

### Option B: OS keychain via `keyring` (recommended)
Store password once:
- `python -m abap_artifacts auth set-password --base-url https://<host>:<port> --client 030 --user <user>`

Then omit `ABAP_PASSWORD` and the tool will read from the keychain.

## Usage

### Fetch a BDEF source via ADT
Example (your URL pattern):
- `abap-artifacts fetch-url --auth 'https://ldciemo.wdf.sap.corp:44300/sap/bc/adt/bo/behaviordefinitions/lstmiroutetpbdef/source/main?version=active&sap-client=030'`

Or use the structured command:
- `abap-artifacts fetch-bdef LSTMIRouteTPBDef --client 030 --version active`

## Fetch ABAP class sources (ADT)

Main class source:
- `abap-artifacts fetch-class cl_farr_cv_odata_atta_persist --client 815 --version active`

Includes:
- `abap-artifacts fetch-class-include cl_farr_cv_odata_atta_persist --include implementations --client 815 --version active`
- `abap-artifacts fetch-class-include cl_farr_cv_odata_atta_persist --include testclasses --client 815 --version active`
- `abap-artifacts fetch-class-include cl_im_sdbil_hdm_attach_persist --include definitions --client 815 --version active`
- `abap-artifacts fetch-class-include cl_im_sdbil_hdm_attach_persist --include macros --client 815 --version active`

### Fetch ABAP Keyword Docu pages (public ICF; no auth)
- `abap-artifacts fetch-docu ABENEML --client 000 --lang EN`

## Notes
- This tool intentionally does **not** print credentials and avoids logging request headers by default.
- For ADT endpoints, authentication is typically required (401 otherwise).
- If you wrap this tool into an MCP server later, ensure the MCP layer never returns secrets or request headers.
