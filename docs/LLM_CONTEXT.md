# LLM Context: PTF (Process Test Framework)

## Purpose
PTF is an ABAP-based **integration test framework** intended to automate end-to-end business-process tests (create/change/check/execute steps) and report results in a consistent way (for example SD → LE → TM → EWM → LMD → FI).

PTF is part of the S/4HANA **HOME layer** (SAP-internal software components; not customer-shipped). When proposing changes, assume an internal SAP environment and avoid “customer release” assumptions (e.g., public API stability, downport constraints) unless explicitly stated.

This Git repository is an **abapGit** serialization of ABAP development objects. The canonical source of truth is the ABAP system during development; Git captures the serialized object state under `src/`.

## How to work with this repo
- **Typical flow:** implement/change in ABAP (ADT/SE80) → run checks/ABAP Unit → serialize via abapGit → commit here.
- **Safe edits in Git:** `src/**/*.abap` (ABAP sources) and Markdown docs. Treat `src/**/*.xml` as generated metadata unless you have a specific reason.

## Execution model note (ABAP Unit as container)
PTF can execute steps inside ABAP Unit (AUnit) sessions (used as an execution container, not only for unit tests). See `docs/AUNIT_EXECUTION.md`.

## Multi-system (decentral) scenarios
PTF can route step execution to different ABAP systems via RFC destinations (side-by-side/decentral deployments). Landscape (`PTF_LANDSCAPE`) is optional and may be unused in the current setup; see `docs/MULTI_SYSTEM_LANDSCAPES.md`.

## Current development goals
For planned extensions (JSON input for non-RAP BOs and RAP `MODIFY` support), see `docs/DEVELOPMENT_GOALS.md`.

## RAP EML reference
For comprehensive EML syntax and patterns (especially `MODIFY ... OPERATIONS` with %CID/%CID_REF), see `docs/EML_SYNTAX_REFERENCE.md`.

For official ABAP documentation links, see `docs/ABAP_REFERENCE.md`.

## What files represent
- `src/<name>.clas.abap`: ABAP source for a class.
- `src/<name>.clas.xml`: class metadata (interfaces, attributes, etc.) as serialized by abapGit.
- `src/<guid>.<type>.xml` (example: `*.avas.xml`): serialized objects whose filenames are not stable/human-readable; generally not meant for manual editing.

## Pointers for navigation
- Look for core abstractions and utilities around `CL_PTF_*` and `APOC_PTF_*` in `src/`.
- Many framework-wide constants and shared types live in `src/cl_ptf_util.clas.abap`.

## When asking an LLM for changes
To get better results, include:
- The ABAP object name(s) (e.g. class/program name) you want to change.
- The desired behavior and an example input/output or scenario.
- Any constraints from your ABAP release/components (see `.abapgit.xml` requirements).

If the change affects runtime behavior, specify how you validate it in the ABAP system (transaction, report, ABAP Unit test, etc.).
