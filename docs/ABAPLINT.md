# ABAP Syntax Checking (abaplint)

This repository uses [abaplint](https://abaplint.org) to validate ABAP syntax locally before pushing to the ABAP system.

## Why abaplint?
- **No ABAP system required**: Parses ABAP offline
- **Fast feedback**: Catches basic syntax errors in seconds
- **CI integration**: Runs automatically on pull requests
- **VS Code extension**: Real-time linting while editing

## Limitations
abaplint cannot validate:
- Custom DDIC types from your ABAP system (unless you add them to `deps/`)
- System-specific checks (ATC, authorization, transport)
- Runtime behavior

**Always activate in ABAP and run checks there as the final validation.**

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

### 3. Enable pre-commit hook (optional)
```bash
# Make executable
chmod +x tools/pre-commit.js

# Link into git hooks
ln -s ../../tools/pre-commit.js .git/hooks/pre-commit
```

Now `git commit` will automatically run abaplint on staged ABAP files.

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
