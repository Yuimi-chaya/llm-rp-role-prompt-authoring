# Role Prompt Authoring Skill

Status: `2.0.0-draft.1`, local pre-release, 2026-09-02.

## Choose One File

- Chinese: `role-prompt-authoring-skill.zh-CN.md`
- English: `role-prompt-authoring-skill.en.md`

The files are semantic counterparts. Provide one complete file to the model responsible for writing or revising a role Prompt. They are not runtime character Prompts themselves.

## Intended Requests

- Create a reusable character definition from ordinary language.
- Produce a deployment Prompt for a known model and private-chat host.
- Recompile a trusted existing character for another model or platform.
- Diagnose real chat failures before deciding what should change.

## Out Of Scope

- Implementing tools, memory, time, scheduling, delivery, or platform code.
- General-purpose prompt optimization unrelated to roleplay.
- Narrative continuation or shared-world roleplay unless a later explicit mode supports it.
- Guaranteeing natural behavior without target-model and human validation.

## Output Rule

The writer should expose only the main artifact requested by the user. Internal assets and manifests are optional non-injectable materials. A target deployment must contain exactly one role Prompt.

See `../../docs/` for maintainer-facing architecture, contracts, runtime profiles, evaluation, and migration guidance.
