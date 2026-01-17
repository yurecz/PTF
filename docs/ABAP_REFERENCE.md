# ABAP reference (ABAP Keyword Documentation)

The SAP ABAP Keyword Documentation is the authoritative reference for ABAP syntax and key platform topics (DDIC, CDS, RAP, EML).

This repo intentionally does **not** vendor/copy the full documentation. Instead, we keep a curated list of the most relevant “object ids” plus short summaries so contributors and LLM tooling can ground changes against the correct source.

## Where to read
Base URL (internal): `https://ldciemo.wdf.sap.corp:44300/sap/public/bc/abap/docu`

Typical link parameters:
- `sap-language=EN`
- `tree=X&version=X` (UI5 version with navigation tree)
- `sap-client=000` (example client; use your system/client as appropriate)
- `object=<OBJECT_ID>` (the important part)

## High-value topics for PTF work

### ABAP Dictionary (DDIC)
- **Object:** `ABENABAP_DICTIONARY`
- **Link:** `...?sap-language=EN&tree=X&version=X&sap-client=000&object=ABENABAP_DICTIONARY`
- **Why:** DDIC types/structures underpin PTF step types, TDC parameters, RAP keys, and message types. Useful when aligning JSON payload fields with ABAP types.

### ABAP CDS
- **Object:** `ABENCDS`
- **Link:** `...?sap-language=EN&tree=X&version=X&sap-client=000&object=ABENCDS`
- **Why:** RAP BO entities are defined via CDS view entities/projections; needed to understand exposed fields, keys, and associations used by EML operations.

### ABAP RAP Business Objects
- **Object:** `ABENABAP_RAP`
- **Link:** `...?sap-language=EN&tree=X&version=X&sap-client=000&object=ABENABAP_RAP`
- **Why:** Top-level RAP documentation hub (concepts, provider/consumer patterns, contracts). Use as starting point when designing new PTF RAP capabilities.

### CDS Behavior Definitions (BDEF)
- **Object:** `ABENCDS_BDEF`
- **Link:** `...?sap-language=EN&tree=X&version=X&sap-client=000&object=ABENCDS_BDEF`
- **Why:** BDEF defines the contract (entities, operations, actions, authorization/locking, etc.) that EML consumes. It’s essential when aligning PTF RAP execution (especially `MODIFY ... OPERATIONS`) with what a RAP BO actually exposes.

### ABAP EML overview (consuming RAP BOs)
- **Object:** `ABENEML`
- **Link:** `...?sap-language=EN&tree=X&version=X&sap-client=000&object=ABENEML`
- **Why:** Entry point for EML concepts and links to the statement pages used by PTF.

### MODIFY ENTITY / ENTITIES (EML)
- **Object:** `abapmodify_entity_entities`
- **Link:** `...?sap-language=EN&tree=X&version=X&sap-client=000&object=abapmodify_entity_entities`
- **Why:** Defines all MODIFY variants, including the dynamic-operations variant used for generic execution.
- **See also:** [EML_SYNTAX_REFERENCE.md](EML_SYNTAX_REFERENCE.md) for PTF-specific EML patterns and %CID/%CID_REF usage.

Key variant (relevant to PTF “MODIFY” goal):
- `MODIFY ENTITIES ... OPERATIONS op_tab [response_param].`

Related subtopics linked from the page:
- **Operations clause details:** `abapmodify_entity_entities_op`
- **Dynamic operations variant:** `abapmodify_entities_operations_dyn`
- **Response parameters (FAILED/REPORTED/MAPPED):** `abapeml_response`

### READ ENTITY / ENTITIES (EML)
- **Object:** `abapread_entity_entities`
- **Link:** `...?sap-language=EN&tree=X&version=X&sap-client=000&object=abapread_entity_entities`
- **Why:** Read and evaluation operations; relevant for `RETRIEVE` / `RETRIEVE_ALL` / `CHECK*` patterns.

### COMMIT ENTITIES
- **Object:** `abapcommit_entities`
- **Link:** `...?sap-language=EN&tree=X&version=X&sap-client=000&object=abapcommit_entities`
- **Why:** Persisting transactional buffer changes and interpreting commit responses.

### GET PERMISSIONS
- **Object:** `abapget_permissions`
- **Link:** `...?sap-language=EN&tree=X&version=X&sap-client=000&object=abapget_permissions`
- **Why:** Feature/permission checks that PTF uses to build valid operations.

### ROLLBACK ENTITIES
- **Object:** `abaprollback_entities`
- **Link:** `...?sap-language=EN&tree=X&version=X&sap-client=000&object=abaprollback_entities`
- **Why:** Transactional buffer rollback for error handling and test isolation.

### SET LOCKS
- **Object:** `abapset_locks`
- **Link:** `...?sap-language=EN&tree=X&version=X&sap-client=000&object=abapset_locks`
- **Why:** Explicit locking semantics for certain test scenarios.

### CONVERT KEY
- **Object:** `abapconvert_key`
- **Link:** `...?sap-language=EN&tree=X&version=X&sap-client=000&object=abapconvert_key`
- **Why:** Key conversion helpers (useful when bridging external representations and RAP technical keys).

## How to use this as grounding (recommended)
- Treat the keyword doc as the **source of truth** for syntax/operand meaning.
- When implementing or changing PTF RAP support, pin the relevant `object=` id(s) and summarize the constraint you’re implementing.
- Avoid copying full pages into Git; keep only minimal summaries and the stable references (object ids).

## Notes for automated retrieval (LLM tooling)
In some environments the internal HTTPS certificate chain may not be trusted. If you script retrieval, ensure your tooling handles the TLS trust appropriately (do not disable verification unless you understand the risk).
