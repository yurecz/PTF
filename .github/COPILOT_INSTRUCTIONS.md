# GitHub Copilot Instructions for PTF Repository

## Critical Workflow for ABAP Code Changes

When modifying ABAP code in this repository:

1. **ALWAYS verify API signatures using MCP BEFORE making changes**
   - Command: `tools/abap_cli.sh fetch-class <CLASS_NAME> --client 815`
   - This fetches the actual API from the ABAP system (ERX/815)

2. **Search existing usage patterns first**
   - Use `grep_search` or `semantic_search` to find similar code
   - Copy patterns from working code rather than guessing

3. **Deploy and test in ABAP system after changes**
   - Changes must be verified in ERX/815 via abapGit
   - Never consider work complete without ABAP system verification

See `AGENTS.md` for complete workflow details.
