# Typical systems/clients (PTF / LMD context)

These are common system/client combinations used in this codebase’s development context. They are safe to store in Git (no credentials) and help standardize examples and tooling defaults.

## Examples
- `EMO/030`: Productive development client for LMD
- `EMO/815`: HOME development client for LMD
- `ERX/815`: HOME development client for S/4CORE (including PTF)

## Notes
- Hostnames/URLs can differ per network/route (e.g., `ldai1emo...` vs `ldciemo...`); keep those in local config/env, not in Git.
- When writing documentation or scripts, prefer referencing system+client in the form `SYS/CLIENT` and allow the base URL to be provided externally.
