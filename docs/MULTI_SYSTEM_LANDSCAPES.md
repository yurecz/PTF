# Multi-system (side-by-side / decentralized) execution

PTF supports end-to-end integration scenarios that span multiple ABAP systems (for example, decentralized TM or decentralized EWM connected to a core system). The mechanism is based on routing each PTF step to an RFC destination (optionally scoped by a “landscape” identifier).

## Key concepts
- **BO-to-destination routing**: determines which ABAP system executes a given step.
  - Resolved by `CL_PTF_RUN->GET_RFC_DESTINATION` reading table `PTF_BO_DEST`: `src/cl_ptf_run.clas.abap:1701`.
  - The lookup supports specificity by `(ptf_landscape, user, business object)`; rows with `PTF_BO`/`USER_NAME` initial act as fallbacks: `src/cl_ptf_run.clas.abap:1703`.
- **Landscape (optional / currently not implemented end-to-end)**: a dimension intended to describe the target system landscape.
  - DDIC table exists: `PTF_LANDSCAPE` (see `src/rfc/ptf_landscape.tabl.xml`), but if your current PTF setup does not set/maintain landscapes, treat landscape as **initial/blank**.
  - In that case, maintain `PTF_BO_DEST` entries with `PTF_LANDSCAPE` initial so routing still works (because `GET_RFC_DESTINATION` filters by the passed value, which is typically initial).

## How a step is executed remotely
When running inside the ABAP Unit execution container (`TCL_PTF_STEP_IN_AU`), PTF routes each step via RFC:
- Destination is calculated per step: `src/tcl_ptf_step_in_au.clas.abap:322`.
- Remote execution happens by calling function module `PTF_INVOKE_ACTION` with `DESTINATION <rfc_dest>`: `src/tcl_ptf_step_in_au.clas.abap:328`.
- On the remote system, `PTF_INVOKE_ACTION`:
  - Instantiates the target BO class (or `CL_PTF_BO_RAP_GENERIC` for RAP BOs) and calls the action method dynamically: `src/rfc/ptf_rfc.fugr.ptf_invoke_action.abap:37`.
  - Returns updated `CS_STEP_DATA`, `CT_STEP_DATA`, logs, statuses, and runtime back to the caller: `src/rfc/ptf_rfc.fugr.ptf_invoke_action.abap:1`.

## Test data container (TDC) and remote systems
Some test data access is designed to work against remote destinations as well:
- `CL_PTF_UTIL` can instantiate the eCATT TDC API with an RFC destination (`I_TDC_RFCDEST`): `src/cl_ptf_util.clas.abap:364`.

## Copying PTF customizing/scripts to decentralized systems
There is tooling to copy PTF table content from a source RFC destination (intended for decentralized systems):
- `CL_PTF_TABU_COPY` uses `RFC_READ_TABLE` against a configured destination and contains the note “Use only in decentral systems”: `src/cl_ptf_tabu_copy.clas.abap:90`.

## Practical prerequisites (high level)
- RFC destinations must exist and be reachable between the involved ABAP systems.
- The remote system must contain the PTF runtime objects (the BO classes, `PTF_RFC` function group, and required DDIC objects).
- Maintain `PTF_BO_DEST` routing consistently; `PTF_LANDSCAPE` is optional in the current framework usage.
