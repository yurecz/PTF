# PTF (Process Test Framework)
ABAP-based integration test framework for process test automation (end-to-end business processes, e.g. SD → LE → TM → EWM → LMD → FI).

Note: This codebase is part of the S/4HANA **HOME layer** (SAP-internal software components; not shipped/assembled for customers).

This repository is an initial extraction of the ABAP package **PTF** and its subpackages from system **ERX/815** using **abapGit** (docs: https://docs.abapgit.org/). The goal is to further develop and maintain the PTF framework in Git.

## Import into an ABAP system (abapGit)
- Install/enable abapGit in your ABAP system.
- Create a new abapGit repository that points to this Git URL.
- Select package (or create one) and pull.
- Activate objects as needed.

Repository metadata is in `.abapgit.xml` (starting folder `/src/`, folder logic `PREFIX`, original system `ERX`).
Minimum software component requirement (from `.abapgit.xml`): `S4COREOP` `>= 110`.

## Repository layout
- `src/`: abapGit-serialized objects (classes, programs, message classes, etc.).
- `src/core/`, `src/util/`, `src/rfc/`, `src/rap/`: package-based subfolders (by abapGit folder logic).
- `*.clas.abap`: ABAP source for classes; related metadata is stored in adjacent `*.xml` files.
- `*.xml` with GUID-like filenames (e.g. `*.avas.xml`): serialized repository objects that don’t have a stable human-readable name; prefer changing them in ABAP and re-serializing via abapGit.

## Development workflow (recommended)
- Make changes in the ABAP system (ADT/SE80), run checks/ABAP Unit as appropriate.
- Use abapGit to **stage** and **commit** changes (serialization updates the `src/` content).
- Keep changes focused; avoid manual edits of generated XML unless necessary.

## LLM / agent setup
This repo includes lightweight guidance for LLM-based coding assistance:
- `AGENTS.md` describes how to navigate/edit this abapGit repo safely.
- `docs/LLM_CONTEXT.md` provides a short, repo-specific overview for prompting and onboarding.
- `docs/AUNIT_EXECUTION.md` documents how PTF uses ABAP Unit sessions as an execution container for productive PTF runs.
- `docs/MULTI_SYSTEM_LANDSCAPES.md` documents cross-system execution via RFC destinations (decentral/side-by-side landscapes).
- `docs/DEVELOPMENT_GOALS.md` captures the current development goals (JSON step input expansion and RAP `MODIFY` support).
- `docs/ABAP_REFERENCE.md` lists key ABAP Keyword Docu pages (object ids) used to ground syntax/platform changes.
- `docs/ABAP_ARTIFACT_TOOLING.md` describes the local tool for fetching ABAP artifacts (BDEF/CDS/DDIC) without storing credentials in Git.
- `docs/ABAP_ADT_URL_PATTERNS.md` summarizes common ADT URL patterns for artifact retrieval.
- `docs/SYSTEM_CLIENTS.md` lists common system/client combinations used in this repo context.
