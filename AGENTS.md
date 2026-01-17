# Agent Notes (LLM/Codex)

This repository is an **abapGit** export of the ABAP package **PTF** (Process Test Framework) and subpackages, originally extracted from **ERX/815**. Most work happens by changing objects in an ABAP system and letting abapGit serialize them into `src/`.

## ⚠️ MANDATORY PRE-FLIGHT CHECKLIST - READ THIS FIRST

**BEFORE touching any code, you MUST complete these steps IN ORDER:**

- [ ] **Step 1: Search for existing patterns** - Use `grep_search` or `semantic_search` to find how the API is currently used in the codebase
- [ ] **Step 2: MANDATORY MCP VERIFICATION** - Use MCP tool to fetch the actual API definition from ERX/815:
  ```bash
  tools/abap_cli.sh fetch-class <CLASS_NAME> --base-url https://ldai1emo.wdf.sap.corp:44300 --client 815 --user PETUKHIN
  ```
  **🛑 CRITICAL: If MCP authentication fails (401 error) or MCP is unavailable:**
  - **STOP IMMEDIATELY** - Do NOT proceed with code changes
  - **INFORM USER** - Explicitly state: "MCP authentication failed. Cannot verify API signatures. STOPPING."
  - **NEVER ASSUME** - Do not guess API signatures, parameter names, or method names
  - **WAIT FOR USER** - Let user resolve authentication or provide verified information
  
- [ ] **Step 3: Check docs/** - Review relevant documentation files for patterns and examples
- [ ] **Step 4: Make changes** - Only now implement changes based on VERIFIED information from MCP

**AFTER making changes:**

- [ ] **Run get_errors** - MANDATORY after every code edit to catch compilation errors immediately
- [ ] **Verify completeness** - If search found N occurrences, verify ALL N are fixed (not just first one)
- [ ] **Deploy to ABAP system** - Changes MUST be tested in ERX/815 via abapGit before considering work complete
- [ ] **Activate and verify** - Check compilation, run tests, verify functionality

❌ **NEVER:** Assume API signatures, guess parameter names, or skip MCP verification
❌ **NEVER:** Proceed if MCP authentication fails - STOP and inform user
❌ **NEVER:** Fix only first occurrence when search shows multiple matches
❌ **NEVER:** Commit without running get_errors to verify no compilation errors
✅ **ALWAYS:** Stop immediately if MCP unavailable - inform user explicitly
✅ **ALWAYS:** Verify with MCP first, code second, deploy third
✅ **ALWAYS:** When search shows N matches, document and fix ALL N relevant matches

## 🔴 SYSTEMATIC FAILURE PREVENTION

**When fixing type errors or repetitive issues:**

1. **SEARCH PHASE:**
   ```bash
   rg -n "problematic_pattern" src/**/*.abap
   ```
   - Document ALL match locations (line numbers)
   - Example: "Found 3 matches: line 1013, 1039, 1450"

2. **ANALYSIS PHASE:**
   - Read context for EACH match location
   - Determine which matches need fixing
   - Example: "Lines 1013 and 1039 need fixing (same method), line 1450 already correct (different context)"

3. **FIX PHASE:**
   - Use multi_replace_string_in_file for multiple fixes
   - Fix ALL identified issues in ONE operation
   - Document what was fixed: "Fixed 2 of 3 occurrences (3rd already correct)"

4. **VERIFICATION PHASE (MANDATORY):**
   - Run `get_errors` on modified files
   - Verify error count is ZERO
   - Read and review complete modified methods/sections for logical correctness
   - Verify all control structures properly nested (IF/ENDIF, LOOP/ENDLOOP, TRY/ENDTRY)
   - Verify all statements end with periods
   - If errors remain, repeat from SEARCH PHASE
   - Only proceed to commit when get_errors returns "No errors found"

5. **COMMIT PHASE:**
   - Only commit after successful verification
   - Include in commit message: "Verified with get_errors - no compilation errors"

**Example of correct workflow:**
```
1. Search: rg -n "add_actual_messages" → found 3 matches
2. Analyze: Lines 1013, 1039, 1450
3. Fix: Changed lines 1013 and 1039 (1450 different context)
4. Verify: get_errors → "No errors found"
5. Commit: "Fix all type conversions in MODIFY method"
```

**This prevents:**
- Incomplete fixes (fixing 1 of N occurrences)
- Committing code with compilation errors
- Discovering errors only after push

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

## Class design guidelines

When creating new ABAP classes, follow **POJO (Plain Old Java Object) methodology**:

- **✅ DO:** Use `create public` for simple, stateless classes
- **✅ DO:** Instantiate directly with `NEW cl_class_name( )`
- **✅ DO:** Make classes testable with constructor injection
- **✅ DO:** Keep classes focused and single-purpose
- **❌ AVOID:** Singleton patterns (`get_instance()`) unless absolutely necessary
- **❌ AVOID:** Global static state that makes testing difficult
- **❌ AVOID:** Complex inheritance hierarchies

**Example - Good POJO pattern:**
```abap
CLASS cl_ptf_rap_metadata DEFINITION
  PUBLIC
  CREATE PUBLIC.
  
  " Simple, stateless, directly instantiable
  DATA(lo_metadata) = NEW cl_ptf_rap_metadata( ).
  DATA(lt_fields) = lo_metadata->get_key_fields( iv_name = 'ENTITY' ).
```

**Example - Avoid unless needed:**
```abap
CLASS cl_singleton DEFINITION
  PUBLIC
  CREATE PRIVATE.  " Forces singleton pattern
  
  CLASS-METHODS get_instance RETURNING VALUE(ro_instance) TYPE REF TO cl_singleton.
```

**Why POJO?** Simpler instantiation, easier testing, clearer dependencies, less coupling.

## CRITICAL: /ui2/cl_json nested references behavior

**⚠️ When using `/ui2/cl_json=>deserialize` with generic `REF TO data` (no compile-time type):**

The deserializer creates **NESTED REFERENCES at ALL levels**, regardless of the `assoc_arrays` parameter:
- Each array element is a reference: `<fs_element>->*` required
- Each structure component VALUE is a reference: `<fs_field>->*` required  
- Nested arrays are references: `<fs_array>->*` required
- This applies recursively to all nested structures

**The `assoc_arrays` parameter only controls:**
- How arrays are represented (associative vs standard tables)
- NOT whether values are wrapped in references

**Example - Multi-level dereferencing required:**
```abap
DATA lr_json_data TYPE REF TO data.

/ui2/cl_json=>deserialize(
  EXPORTING json = lv_json assoc_arrays = abap_off
  CHANGING data = lr_json_data ).

ASSIGN lr_json_data->* TO <ft_operations>.

LOOP AT <ft_operations> ASSIGNING <fs_op>.
  " Level 1: Dereference array element to get structure
  ASSIGN <fs_op>->* TO <ls_operation>.
  
  " Level 2: Dereference structure component to get value
  ASSIGN COMPONENT 'FIELD' OF STRUCTURE <ls_operation> TO <fs_field>.
  DATA(lv_value) = CONV string( <fs_field>->* ).  " Must dereference!
  
  " Level 3: Nested arrays also need dereferencing
  ASSIGN COMPONENT 'ITEMS' OF STRUCTURE <ls_operation> TO <fs_items>.
  ASSIGN <fs_items>->* TO <ft_items>.  " Dereference array
  
  LOOP AT <ft_items> ASSIGNING <fs_item>.
    ASSIGN <fs_item>->* TO <ls_item>.  " Dereference element
    " ... and so on recursively
  ENDLOOP.
ENDLOOP.
```

**Why this happens:**
- Without compile-time type information, the deserializer can't know the target structure
- It creates a fully dynamic structure with references at every level
- This allows maximum flexibility but requires explicit dereferencing

**Best practice:**
- Add TRY-CATCH for `cx_sy_assign_illegal_cast` as safe fallback
- Use inline comments to document each dereferencing level
- See `src/rap/cl_ptf_rap_modify_executor.clas.abap` method `deserialize_json` for complete example

**Reference:** https://github.com/SAP/abap-to-json/blob/main/docs/data-access.md

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
   - **🛑 CRITICAL: If MCP authentication fails (401 error) or MCP is unavailable:**
     - **STOP IMMEDIATELY** - Do NOT proceed with code changes
     - **INFORM USER** - Explicitly state: "MCP authentication failed. Cannot verify API signatures. STOPPING."
     - **NEVER ASSUME** - Do not guess API signatures, parameter names, or method names
     - **WAIT FOR USER** - Let user resolve authentication or provide verified information
   - **Case sensitivity matters:** When grepping ABAP source fails, try different case. Keywords are typically lowercase (`begin of`, `method`, `data`), names typically uppercase (`CL_CLASS`, `IF_INTERFACE`). If grep finds nothing, try the opposite case.
   - See `docs/MCP_SETUP.md` for MCP configuration
   - ❌ NEVER assume parameter names or API signatures without verification
   - ❌ NEVER proceed if MCP authentication fails - STOP and inform user
   - ✅ ALWAYS verify with MCP before making code changes
   - ✅ ALWAYS stop immediately if MCP unavailable - inform user explicitly
3. **Check documentation** in `docs/` folder for patterns and examples
4. **Only then make changes** based on VERIFIED information from MCP

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

## MCP authentication troubleshooting

**When MCP returns 401 Unauthorized, follow this checklist:**

1. **Check environment variables FIRST** (most common issue):
   ```bash
   env | grep -i abap
   ```
   - If `ABAP_PASSWORD` is set, it overrides keyring
   - If password is wrong/truncated, unset it: `unset ABAP_PASSWORD`
   - Example issue: `ABAP_PASSWORD=Mamont1982` (10 chars) vs keyring has `Mamont1982Mamont1982` (20 chars)

2. **Verify keyring has correct password**:
   ```bash
   PYTHON_KEYRING_BACKEND=keyrings.alt.file.PlaintextKeyring python3 -c "
   import keyring
   pw = keyring.get_password('abap_artifacts::https://ldai1emo.wdf.sap.corp:44300::client::815', 'PETUKHIN')
   print(f'Password length: {len(pw)}' if pw else 'No password found')
   "
   ```

3. **Test authentication with curl** (bypasses Python entirely):
   ```bash
   curl -u "PETUKHIN:PASSWORD" -k "https://ldai1emo.wdf.sap.corp:44300/sap/bc/adt/repository/nodestructure?sap-client=815"
   ```
   - If curl works but MCP fails → environment variable issue
   - If curl fails → password is wrong

4. **Test MCP with explicit password** (bypass keyring):
   ```bash
   python3 -m abap_artifacts fetch-class CL_ABAP_STRUCTDESCR \
     --base-url https://ldai1emo.wdf.sap.corp:44300 --client 815 \
     --user PETUKHIN --password "PASSWORD" --no-keyring --insecure
   ```
   - If this works → keyring issue
   - If this fails → password/network issue

5. **Common causes** (in order of frequency):
   - Stale `ABAP_PASSWORD` environment variable overriding keyring
   - Missing `--client 815` parameter in curl tests
   - Wrong username case (though usually works with both)
   - Password actually expired/changed in ABAP system

**Resolution:**
- Remove or update `ABAP_PASSWORD` in shell configs (~/.bashrc, ~/.profile)
- Update keyring password: `python3 -m abap_artifacts auth set-password --base-url ... --client 815 --user PETUKHIN`
- Check password actually works in ABAP GUI before troubleshooting further

## Useful searches
- Find a class: `rg -n \"^CLASS\\s+cl_\" src`
- Find references: `rg -n \"cl_ptf_\" src`
- Find a message ID: `rg -n \"\\.msag\\.xml\" src`
