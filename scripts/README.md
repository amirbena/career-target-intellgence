# scripts/

Tooling only; no product behavior. Usage and the build/validation overview
are in [../docs/development.md](../docs/development.md).

- `package/` — build the Claude Skill, Plugin, external kit and ChatGPT Plugin ZIPs, and generate the ChatGPT knowledge bundles (`.sh`, with `.ps1` equivalents for most).
- `validate/` — branch-name, PR release label, Skill description, Claude plugin manifest, and archive-version checks.
- `release/` — `release.sh`, the release script.
