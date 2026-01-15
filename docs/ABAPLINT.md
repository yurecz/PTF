# ABAP Syntax Checking (abaplint)

**Status: Pre-commit hook DISABLED** (2026-01-15)

This repository has [abaplint](https://abaplint.org) configured but the pre-commit hook is disabled because:
- The ABAP system (ERX/815) is the source of truth for validation
- 1000+ existing "violations" are mostly style preferences, not real errors
- MCP verification + ABAP activation is the mandatory workflow (see AGENTS.md)

abaplint remains available for reference but doesn't block commits.

## Original intent
- **No ABAP system required**: Parses ABAP offline
- **Fast feedback**: Catches basic syntax errors in seconds
- **CI integration**: Runs automatically on pull requests
- **VS Code extension**: Real-time linting while editing

## Limitations
abaplint cannot validate:
- Custom DDIC types from your ABAP system (unless you add them to `deps/`)
- System-specific checks (ATC, authorization, transport)
- Runtime behavior
- **RAP framework API completeness**: Method existence in classes like `cl_abap_behvdescr`, exception class hierarchies (e.g., `cx_abap_behv` subclasses), and other newer SAP framework APIs may not be in abaplint's validation database

**Always activate in ABAP and run checks there as the final validation.**

### Known gaps (2026-01-14)
During RAP MODIFY implementation, abaplint missed these semantic errors that were caught by ERX/815:
- `cl_abap_behvdescr=>get_by_entity()` doesn't exist (correct: `describe_by_name()`)
- `lo_behv_descr->get_field_type()` doesn't exist (correct: `get_type()`)
- `cx_abap_behv_not_found` doesn't exist (correct: use parent `cx_abap_behv`)

**Lesson**: abaplint validates ABAP grammar/syntax but cannot fully validate SAP framework semantics. The ABAP system is the only source of truth for method signatures and class hierarchies.

## Setup

### 1. Install abaplint globally
```bash
npm install -g @abaplint/cli
```

### 2. Run manually
```bash
# From repo root
abaplint
```

### 3. Enable pre-commit hook (CURRENTLY DISABLED)
The pre-commit hook was disabled on 2026-01-15 because abaplint validation is not reliable enough for this project (see top of document).

If you want to re-enable it:
```bash
# Restore the hook
mv .git/hooks/pre-commit.disabled .git/hooks/pre-commit
```

### 4. VS Code extension (recommended)
Install the [abaplint extension](https://marketplace.visualstudio.com/items?itemName=larshp.vscode-abaplint) for real-time feedback.

## Configuration
Edit `.abaplint.json` to:
- Adjust ABAP version (`syntax.version`)
- Enable/disable specific rules
- Add dependencies (DDIC types from other repos)

## CI/CD
The GitHub Actions workflow (`.github/workflows/abaplint.yml`) runs automatically on:
- Pull requests touching `src/**/*.abap`
- Pushes to `main`

## Bypassing checks
If you need to commit despite abaplint errors (e.g., system-specific code):
```bash
git commit --no-verify
```

## Common issues

### "Unknown type XYZ"
Add the type to `deps/` or mark as external in `.abaplint.json`:
```json
"syntax": {
  "globalConstants": ["c_my_constant"],
  "globalMacros": []
}
```

### False positives
Disable specific rules in `.abaplint.json` or use inline suppressions:
```abap
" abaplint:disable rule_name
<code>
" abaplint:enable rule_name
```

## References
- [abaplint documentation](https://docs.abaplint.org)
- [abaplint rules reference](https://rules.abaplint.org)
