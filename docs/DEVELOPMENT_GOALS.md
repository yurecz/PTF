# Development Goals

This document captures the two main upcoming goals for evolving PTF.

## Goal 1: JSON payload support for all PTF BO actions
**Problem today**
- JSON step input is primarily supported for RAP BO execution, while many “classic” PTF BOs read input from ABAP eCATT Test Data Containers (TDC/TDCV).
- This makes automation and portability harder (especially for generated/templated tests and cross-system runs).

**Goal**
- Allow PTF actions (not only RAP BOs) to accept input via a JSON payload, using the same step field (`JSON_FILE` / `DATA_OBJECT_JSON`) model that already exists in the framework.
- Keep TDC/TDCV as a supported input option where it makes sense, but make JSON a first-class alternative for non-RAP BOs.

**Relevant code areas**
- Step data fields include `TEST_DATA_CONTAINER`, `VARIANT`, `JSON_FILE`: `src/cl_ptf_util.clas.abap:59`.
- RAP BO path already builds test data from JSON via `CL_PTF_JSON=>DESERIALIZE`: `src/cl_ptf_bo_rap_generic.clas.abap:1157`.

**Acceptance criteria**
- For at least one non-RAP BO, the action can be executed with JSON-only input (no TDC/TDCV) and produces identical behavior to the TDC-driven path.
- JSON templates/sample payloads can be generated or documented for the supported actions.

## Goal 2: Add RAP EML-level `MODIFY` action support (standard RAP input model)
**Problem today**
- PTF’s RAP support exposes a set of PTF-specific “actions” (create/change/delete/retrieve/etc.). This does not map 1:1 to RAP EML capabilities and can limit what can be tested for a RAP BO.
- RAP EML’s central operation is `MODIFY ENTITIES … OPERATIONS ct_operations …`, which can represent multiple entity operations in one request.

**Goal**
- Introduce a PTF action/method called `MODIFY` for RAP BOs that:
  - Executes a generic EML `MODIFY ENTITIES` with an operations table (standard RAP model).
  - Accepts input parameters according to RAP documentation (operations list, instances, control, parameters, etc.), instead of PTF-specific action names that do not exist in EML.

**Relevant code areas**
- EML `MODIFY ENTITIES` wrapper exists: `src/cl_ptf_bo_rap_generic_eml.clas.abap:209`.
- Current RAP BO execution still calls EML MODIFY internally, but via PTF action mapping: `src/cl_ptf_bo_rap_generic.clas.abap:1454`.

**Acceptance criteria**
- A PTF step with action `MODIFY` can execute a RAP BO request that cannot be expressed via the current PTF action set (e.g., multiple operations in a single MODIFY or a RAP operation type not currently mapped).
- JSON sample/template generation is available for `MODIFY` payloads (or clearly documented).

**Progress tracking**
- [x] **Step 1** (2026-01-14): Added minimal MODIFY method to CL_PTF_BO_RAP_GENERIC (commit 44a94d5)
  - Method signature matches other RAP actions (IV_STEP_NUMBER in, EV_DOCUMENT_ID/EV_EXECUTION_STATUS/EV_CHECK_STATUS out)
  - Minimal implementation: returns success without executing EML
  - Automatically discoverable via class reflection (no PTFBOA table entry needed)
  - Ready for abapGit deployment and testing
- [ ] **Step 2**: Implement actual EML MODIFY logic
  - Call existing `mo_ptf_bo_rap_generic_eml->modify_entities()` wrapper
  - Build operations table from JSON input
  - Handle FAILED/MAPPED/REPORTED responses
- [ ] **Step 3**: Add JSON deserialization for MODIFY payload
  - Create deserializer that converts EML-style JSON to ABP_BEHV_CHANGES_TAB
  - Support operations array with op/entity/instances structure
  - Handle %cid generation and %cid_ref wiring
- [ ] **Step 4**: Add JSON template generation for MODIFY action
  - Extend CL_PTF_JSON=>GENERATE_SAMPLE_JSON to recognize MODIFY action
  - Generate BO-specific templates based on BDEF metadata
- [ ] **Step 5**: End-to-end testing with real RAP BO
