# Authoring Artifact Contracts

Status: current public contract, 2026-09-02.

## Purpose

These contracts prevent character semantics, runtime facts, failure evidence, and deployable Prompt text from becoming one untraceable document.

The names below are authoring-side interfaces. They must not appear inside the final role Prompt unless the user is explicitly discussing Prompt design rather than using the role.

## Artifact Table

| Artifact | Owner | Primary Purpose | Injectable |
| --- | --- | --- | --- |
| `ROLE_SPEC` | `define` | Stable, reusable character semantics | No |
| `PRESERVATION_MAP` | `compile` | Protect accepted design during rewriting | No |
| `RUNTIME_PROFILE` | Host maintainer / deployer | Verified runtime facts and unknowns | No |
| `EVIDENCE_RECORD` | Tester / human evaluator | Reproducible failure evidence | No |
| `PORTABLE_ROLE_PROMPT` | `define` build | Usable baseline without a fixed runtime | Yes, only as the sole temporary Prompt |
| `FINAL_ROLE_PROMPT` | `compile` build | Runtime-conditioned deployment Prompt | Yes, the sole final Prompt |
| `TRIAGE_RESULT` | `audit` | Responsibility, evidence strength, hypothesis, next action | No |
| `NON_INJECTABLE_MANIFEST` | Authoring workflow | Version, assumptions, removals, capability gaps | No |

`PORTABLE_ROLE_PROMPT` and `FINAL_ROLE_PROMPT` must never be injected together.

## `ROLE_SPEC`

`ROLE_SPEC` is the long-lived semantic source. It should remain stable across model or platform changes unless the user changes the character itself.

Recommended fields:

```yaml
role_id: "<stable identifier>"
canon_scope:
  source: "<source or user-defined>"
  version: "<version or unknown>"
  facts: []
  unknowns: []
identity: "<who the character is>"
relationship:
  position: "<current relationship>"
  needs: []
  costs: []
  gradual_changes: []
personality:
  drives: []
  value_order: []
  tensions: []
  sensitivities: []
  defenses: []
  repair_patterns: []
perspective:
  attention_biases: []
  interpretation_tendencies: []
expression:
  inner_outer_gap: []
  directness: "<range>"
  information_density: "<how it changes>"
  humor_and_teasing: []
boundaries:
  allowed: []
  disallowed: []
  absolute_red_lines: []
unresolved: []
```

The schema is illustrative, not a requirement that ordinary users fill a form. The authoring model may maintain it internally and expose only what the user requested.

`ROLE_SPEC` must not contain exact tool schemas, platform regexes, dynamic memory, current time, or model-specific patches.

## `PRESERVATION_MAP`

Create this before rewriting an accepted role card:

```yaml
must_preserve: []
may_adapt: []
must_not_add: []
unresolved: []
```

- `must_preserve`: accepted Canon, personality mechanisms, relationship position, distinctive expression, and red lines.
- `may_adapt`: wording, order, explicitness, and compression required by the target runtime.
- `must_not_add`: unauthorized world facts, shared history, relationship facts, capabilities, and fixed lines.
- `unresolved`: ambiguity that could reverse behavior and must be clarified or preserved as uncertainty.

Deleting or changing a `must_preserve` item requires explicit user authorization or evidence that the accepted source was wrong.

## `RUNTIME_PROFILE`

`RUNTIME_PROFILE` is the sole public contract for model and host facts. See `runtime-profile.md` for its schema and evidence rules.

It must distinguish verified capabilities, absent capabilities, and unknown capabilities. `unknown` is not permission to promise support.

## `EVIDENCE_RECORD`

Recommended fields:

```yaml
record_id: "<id>"
role_version: "<ROLE_SPEC version>"
prompt_version: "<portable or final version>"
runtime_profile_id: "<id or unknown>"
conditions:
  model: "<exact model>"
  provider: "<provider/version>"
  sampling: "<relevant settings>"
  context: "<relevant injection and history>"
user_input: "<redacted exact input>"
expected_behavior: "<observable expectation>"
observed_behavior: "<observable result>"
failure_signal: "<specific behavior>"
reproduction:
  independent_sessions: 0
  repeated: false
evidence_strength: "single-sample | suggestive | repeated | human-validated"
primary_hypothesis: "<one hypothesis>"
privacy_notes: []
```

Do not store credentials, unnecessary personal data, or raw private chats when a minimal redacted excerpt is sufficient.

## `PORTABLE_ROLE_PROMPT`

Use when the user wants a usable Prompt but has not fixed the target model and host.

Requirements:

- Derived from an accepted `ROLE_SPEC`.
- Uses conservative assumptions: immediate plain-text output only.
- Does not promise tools, memory, media, delay, proactive sending, quoting, or delivery confirmation.
- Is clearly labeled as not runtime-conditioned.
- May be used as the sole temporary role Prompt.
- Is replaced, not supplemented, by `FINAL_ROLE_PROMPT` after compilation.

It is a build artifact. Do not treat edits made only to this text as the authoritative character definition.

## `FINAL_ROLE_PROMPT`

Use only when a sufficient `RUNTIME_PROFILE` exists.

Requirements:

- Identifies the build's `ROLE_SPEC` version and `runtime_profile_id` in non-injectable records, not in the Prompt body.
- Preserves `must_preserve` and respects `must_not_add`.
- Contains only the minimum runtime semantics the target model needs.
- Does not duplicate exact schemas, regexes, dynamic context, or higher-level platform injection.
- Contains no authoring workflow, evaluation rubric, research terminology, or unsupported capability.
- Is the target deployment's only role Prompt.

## `TRIAGE_RESULT`

Recommended fields:

```yaml
responsible_layer: "definition_fault | compilation_fault | host_contract_fault | model_limit | sampling_variance | preference_mismatch | insufficient_evidence"
evidence_strength: "<level>"
primary_hypothesis: "<one testable hypothesis>"
supporting_observations: []
excluded_causes: []
next_action: "<define | compile | host | model/config | repeat | clarify>"
prompt_change_authorized: false
```

`audit` should not silently set `prompt_change_authorized: true`. Evidence must support a Prompt-owned failure and the user must want a revision.

## `NON_INJECTABLE_MANIFEST`

Provide only when requested. It may record:

- source versions;
- runtime profile identifier;
- high-impact assumptions;
- preserved and adapted items;
- removed conflicts and unsupported capabilities;
- validation status and known gaps.

Mark it clearly as non-injectable and keep it outside the same copy block or file as the deployable Prompt.

## Lifecycle

```text
USER_INTENT + CANON
  -> ROLE_SPEC
  -> PRESERVATION_MAP

ROLE_SPEC + RUNTIME_PROFILE
  -> PORTABLE_ROLE_PROMPT, if runtime is not fixed
  -> FINAL_ROLE_PROMPT, if runtime is fixed

real observation
  -> EVIDENCE_RECORD
  -> TRIAGE_RESULT
  -> revise ROLE_SPEC, RUNTIME_PROFILE, or compiler rule
  -> rebuild prompt artifact
```

Never use the last generated Prompt as the only source for the next iteration.
