# Contributing

This repository contains SAP-internal ABAP sources from the S/4HANA **HOME layer** (not shipped/assembled for customers). Please keep that context in mind when describing requirements, dependencies, and validation.

## Development model (abapGit-first)
This repository stores ABAP development objects serialized by **abapGit** under `src/`.

Recommended workflow:
1. Pull the repo into an ABAP system via abapGit.
2. Make and activate changes in ABAP (ADT/SE80).
3. Run validations in the ABAP system (syntax check, ATC where available, ABAP Unit where applicable).
4. Use abapGit to **stage** and **commit** the serialized changes back to Git.

## What to change in Git
- Prefer changes to `src/**/*.abap` and documentation.
- Treat `src/**/*.xml` as generated metadata unless you intentionally change serialization output.
- Avoid reformatting unrelated ABAP code to keep diffs reviewable.

## Pull request hygiene
- Describe the functional change and how it was validated in ABAP.
- Include the ABAP object names you touched (e.g. `CL_PTF_*`, `APOC_PTF_*`).
- Keep PRs small and focused (one feature/fix per PR).
