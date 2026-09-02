# Skills

## Current Entry

Use exactly one language version from `role-prompt-authoring/`:

- `role-prompt-authoring/role-prompt-authoring-skill.zh-CN.md`
- `role-prompt-authoring/role-prompt-authoring-skill.en.md`

Both files describe the same authoring workflow. They are standalone Markdown prompts for a prompt-writing model, not Codex-installable `SKILL.md` packages.

Do not load both language versions at once. Do not combine either current file with archived Skills.

## What The Current Skill Produces

The Skill internally routes among `define`, `compile`, and `audit`, but returns only the main artifact required by the user's current request:

- a reusable `ROLE_SPEC`;
- an unconditioned `PORTABLE_ROLE_PROMPT` when explicitly requested;
- a runtime-bound `FINAL_ROLE_PROMPT`;
- a diagnostic `TRIAGE_RESULT`;
- or a non-injectable `EVALUATION_PLAN`.

Only one prompt may be used for a target deployment. `PORTABLE_ROLE_PROMPT` and `FINAL_ROLE_PROMPT` must never be injected together.

Every portable or final build also retains a minimal non-injectable `BUILD_RECORD`. This provenance sidecar is not another role Prompt.

## Historical Files

Historical and experimental authoring files live under `../archive/`. They are preserved for migration and reproducibility, not discovery or automatic selection.
