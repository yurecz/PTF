# ABAP Unit (AUnit) as Execution Container in PTF

PTF is an **integration test framework** for end-to-end business processes (e.g. SD → LE → TM → EWM → LMD → FI). A PTF “run” executes a sequence of steps (business object + action + input), records results, and writes an execution log.

In many systems, PTF executes steps **inside ABAP Unit sessions**. This is intentional: ABAP Unit provides a controlled execution container and permission/risk-level checks that PTF reuses for productive integration-test execution.

## Where this is implemented
- Run orchestration and AUnit session handling: `src/cl_ptf_run.clas.abap`
  - ABAP Unit permission/risk checks: `src/cl_ptf_run.clas.abap:357`
  - AUnit session start for full run: `src/cl_ptf_run.clas.abap:388`
  - AUnit “container” classes used by name: `src/cl_ptf_run.clas.abap:316` (`TCL_PTF_STEP_IN_AU`, `TCL_PTF_FULL_RUN_IN_AU`)
- AUnit step container (executes one step from ABAP memory): `src/tcl_ptf_step_in_au.clas.abap`
  - Imports step data from memory ID `CG__PTF_STEP`: `src/tcl_ptf_step_in_au.clas.abap:73`
- Wrapper that can execute via ABAP Unit task API: `src/cl_ptf_wrapper.clas.abap:371`

## Operational notes
- AUnit execution depends on client configuration and risk level permissions (see transaction `SAUNIT_CLIENT_SETUP`).
- PTF control parameter `USE_AUNIT` can disable AUnit-per-step mode (read in `src/cl_ptf_run.clas.abap:314`).
- PTF may use one overall AUnit session for the whole run in specific cases (see comment and logic in `src/cl_ptf_run.clas.abap:341`).

## Why it matters when extending input handling (JSON vs TDC)
Because steps may run in an AUnit session, state-sharing is frequently done via ABAP memory IDs. When adding new step input mechanisms (e.g., JSON payload support for non-RAP BOs), keep in mind:
- Step input fields (`test_data_container`, `variant`, `json_file`) are part of the step model in `src/cl_ptf_util.clas.abap:59`.
- The AUnit container classes import/export step data via ABAP memory; any new step attributes must remain serializable through that mechanism.
