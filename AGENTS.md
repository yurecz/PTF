# Agent Notes (LLM/Codex)

This repository is an **abapGit** export of the ABAP package **PTF** (Process Test Framework) and subpackages, originally extracted from **ERX/815**. Most work happens by changing objects in an ABAP system and letting abapGit serialize them into `src/`.

## ⚠️ MANDATORY PRE-FLIGHT CHECKLIST - READ THIS FIRST

**BEFORE touching any code, you MUST complete these steps IN ORDER:**

- [ ] **Step 1: Search for existing patterns** - Use `grep_search` or `semantic_search` to find how the API is currently used in the codebase
- [ ] **Step 2: VERIFY with MCP** - Use MCP tool to fetch the actual API definition from ERX/815:
  ```bash
  tools/abap_cli.sh fetch-class <CLASS_NAME> --base-url https://ldai1emo.wdf.sap.corp:44300 --client 815 --user PETUKHIN
  ```
- [ ] **Step 3: Check docs/** - Review relevant documentation files for patterns and examples
- [ ] **Step 4: Make changes** - Only now implement changes based on verified information

**AFTER making changes:**

- [ ] **Deploy to ABAP system** - Changes MUST be tested in ERX/815 via abapGit before considering work complete
- [ ] **Activate and verify** - Check compilation, run tests, verify functionality

❌ **NEVER:** Assume API signatures, guess parameter names, or skip MCP verification
✅ **ALWAYS:** Verify first, code second, deploy third

## What to edit (and what not to)
- Prefer editing `src/**/*.abap` (class/program sources) and let abapGit manage the adjacent `*.xml` metadata.
- Avoid hand-editing generated `*.xml` unless you know the object format and the change is intentional.
- Some objects are serialized with GUID-like filenames (e.g. `*.avas.xml`). Treat these as generated exports; change them in ABAP and re-serialize when possible.

## Repo structure quick map
- `README.md`: high-level purpose and abapGit usage.
- `.abapgit.xml`: abapGit repo settings (starting folder, folder logic, original system).
- `src/`: abapGit-serialized ABAP objects.
- `src/core/`, `src/util/`, `src/rfc/`, `src/rap/`: package-oriented subfolders.
- `src/rap/cl_ptf_rap_modify_json.clas.abap`: Deserializes EML-style MODIFY JSON to ABP_BEHV_CHANGES_TAB.
- `src/rap/cl_ptf_rap_modify_template.clas.abap`: Generates BO-specific MODIFY operation templates.
- `docs/DEVELOPMENT_GOALS.md`: current development goals and acceptance criteria.

## RAP MODIFY architectural pattern
- The MODIFY action uses a different JSON format than other PTF RAP actions:
  - **MODIFY format**: EML operations array `[{op, entity, instances}]` matching standard RAP EML
  - **Other actions format**: Traditional PTF structure `{fields: [], associations: []}`
- In `cl_ptf_json.clas.abap`, MODIFY case calls `cl_ptf_rap_modify_template=>generate()` with RETURN
- This bypasses shared template generation logic (get_permissions, generate_json_fields, pretty_printer)
- Other actions fall through to shared logic after CASE statement
- This separation is intentional: MODIFY needs fundamentally different JSON structure

## Working style
- Keep patches small and scoped to the requested change.
- Do not reformat unrelated ABAP code.
- When searching, prefer `rg` (ripgrep) and include the ABAP object name in the query when possible.
- **Always track progress** when working on goals from `docs/DEVELOPMENT_GOALS.md`:
  - Add a "Progress tracking" section under the relevant goal
  - Mark completed steps with `[x]` and date/commit reference
  - List remaining steps with `[ ]` and brief descriptions
  - This helps future LLM sessions continue work incrementally

## CRITICAL: Research-first workflow
**BEFORE making any code changes, ALWAYS:**
1. **Search existing working code** for the same API/pattern using `grep_search` or `semantic_search`
   - Example: Before using `cl_abap_behvdescr=>create_data()`, search for existing usage: `rg -n "create_data\(" src/**/*.abap`
   - Copy parameter names and patterns from working code
2. **MANDATORY: Use MCP to verify API signatures** from the actual ABAP system (ERX/815)
   - Use MCP tool to fetch class definition from ABAP system
   - If MCP is unavailable, fall back to CLI wrapper: `tools/abap_cli.sh fetch-class <NAME> --base-url https://ldai1emo.wdf.sap.corp:44300 --client 815 --user PETUKHIN`
   - Raw CLI fallback: `PYTHON_KEYRING_BACKEND=keyrings.alt.file.PlaintextKeyring PYTHONPATH=tools/abap_artifacts python3 -m abap_artifacts fetch-class <NAME> --base-url https://ldai1emo.wdf.sap.corp:44300 --client 815 --user PETUKHIN`
   - See `docs/MCP_SETUP.md` for MCP configuration
   - ❌ NEVER assume parameter names or API signatures without verification
   - ✅ ALWAYS verify with MCP before making code changes
3. **Check documentation** in `docs/` folder for patterns and examples
4. **Only then make changes** based on verified information

**AFTER making code changes, MANDATORY:**
5. **ALWAYS deploy and verify in ABAP system (ERX/815)**
   - Changes MUST be tested in the actual ABAP system before considering them complete
   - Use abapGit to pull changes into ERX/815
   - Activate objects in ABAP system
   - Check for compilation errors
   - Run relevant tests to verify functionality
   - ❌ NEVER assume changes work without ABAP system verification
   - ✅ Only mark work as complete after successful ABAP system validation

**Common mistakes to avoid:**
- ❌ Guessing API parameter names (e.g., assuming `p_tab` instead of checking existing code shows `p_data`)
- ❌ Using non-existent constants (e.g., `if_abap_behv=>op-m-execute` doesn't exist; use `op-m-action` for actions)
- ❌ Making assumptions about ABAP APIs without verification
- ❌ Committing code without testing in ABAP system first
- ❌ Relying solely on MCP/CLI verification without deployment testing
- ❌ Skipping MCP verification and assuming API signatures are correct
- ✅ Always search for existing usage patterns first
- ✅ ALWAYS use MCP to verify API signatures before making changes
- ✅ Follow established codebase conventions
- ✅ Deploy to ABAP system and verify compilation/execution success

## Default environment assumptions
- The developer machine is Windows.
- Work happens in VSCode with the Codex extension.
- VSCode and the Codex extension run in WSL (Ubuntu) for this repo.
- When troubleshooting Codex/MCP, check the latest WSL log at `~/.vscode-server/data/logs/<timestamp>/exthost*/openai.chatgpt/Codex.log`.
- Do not run `sudo` commands; provide exact instructions for the user to run with their password when root access is needed.
- MCP is configured in `.vscode/settings.json` to launch the wrapper script `.vscode/abap_mcp.sh`, which runs `python3 -m abap_artifacts_mcp` with the required environment.
- Use `tools/sync_mcp_config.sh` to sync repo MCP settings into the global WSL MCP config (`~/.vscode-server/data/User/mcp.json`).
- MCP setup details: `docs/MCP_SETUP.md`.

## MCP server limitations
- **GitHub Copilot Chat cannot access MCP servers** in this environment (blocked by administrator settings).
- Codex can access MCP servers when configured (see `docs/MCP_SETUP.md`).
- If MCP is unavailable, fall back to the CLI wrapper: `tools/abap_cli.sh fetch-class <name> --client 815`
- See `tools/abap_artifacts/README.md` for CLI usage.

## Useful searches
- Find a class: `rg -n \"^CLASS\\s+cl_\" src`
- Find references: `rg -n \"cl_ptf_\" src`
- Find a message ID: `rg -n \"\\.msag\\.xml\" src`
