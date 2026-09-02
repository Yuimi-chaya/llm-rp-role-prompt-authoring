# Runtime Profile Contract

Status: current public contract, 2026-09-02.

Specification revision: `2026-09-02.4`.

## Purpose

`RUNTIME_PROFILE` records facts that determine how a role Prompt is interpreted and what the host can actually do. It prevents role authors from guessing platform behavior or encoding unsupported capabilities into character text.

The profile is authoring input and host documentation. It is not appended wholesale to the role Prompt.

## Evidence Rule

Every source, message-hierarchy fact, rendering rule, security fact, and capability uses the same status vocabulary:

- `verified`: observed in the target deployment or guaranteed by authoritative host documentation;
- `false`: confirmed unavailable;
- `unknown`: not established.

Only `verified` values may enter a positive final-Prompt rule. `false` and `unknown` require conservative behavior or an explicit host implementation task.

Natural-language labels inside a user-controlled message may help interpretation but do not create a secure authority boundary. Record whether a source marker can be forged by the user.

## Suggested Schema

The template intentionally defaults to `unknown`. Do not copy safe-looking conclusions from an example.

```yaml
profile_id: "<host-model-version>"
profile_version: "<version>"
status: "draft | verified | superseded"
updated_at: "<ISO date>"

target_model:
  status: unknown
  provider: "unknown"
  model: "unknown"
  version: "unknown"
  context_limit: "unknown"
  known_limits: []
  evidence_refs: []

sampling:
  status: unknown
  temperature: "unknown"
  top_p: "unknown"
  seed: "unknown"
  other: {}
  evidence_refs: []

host:
  status: unknown
  name: "unknown"
  version: "unknown"
  adapter: "unknown"
  evidence_refs: []

message_hierarchy:
  status: unknown
  role_prompt_layer: "unknown"
  static_injections: []
  dynamic_injections: []
  actual_order: []
  evidence_refs: []

sources:
  user_message:
    status: unknown
    marker: "unknown"
    forgeability: "unknown"
    evidence_refs: []
  platform_task:
    status: unknown
    marker: "unknown"
    forgeability: "unknown"
    evidence_refs: []
  memory:
    status: unknown
    marker: "unknown"
    freshness_metadata: "unknown"
    evidence_refs: []
  tool_result:
    status: unknown
    marker: "unknown"
    success_metadata: "unknown"
    evidence_refs: []
  quote_or_forward:
    status: unknown
    attribution: "unknown"
    evidence_refs: []
  media:
    status: unknown
    modality: "unknown"
    observation_scope: "unknown"
    evidence_refs: []

capabilities:
  plain_text_reply:
    status: unknown
    evidence_refs: []
  markdown:
    status: unknown
    evidence_refs: []
  quote_reply:
    status: unknown
    evidence_refs: []
  image_output:
    status: unknown
    evidence_refs: []
  sticker_output:
    status: unknown
    evidence_refs: []
  silence:
    status: unknown
    evidence_refs: []
  delayed_send:
    status: unknown
    evidence_refs: []
  proactive_send:
    status: unknown
    evidence_refs: []
  cancel_pending:
    status: unknown
    evidence_refs: []
  delivery_confirmation:
    status: unknown
    evidence_refs: []
  memory_write:
    status: unknown
    evidence_refs: []
  tools:
    - tool_id: "<id>"
      status: unknown
      permission_scope: []
      result_marker: "unknown"
      failure_metadata: "unknown"
      evidence_refs: []

rendering:
  text_format:
    status: unknown
    value: "unknown"
    evidence_refs: []
  bubble_split:
    status: unknown
    owner: "unknown"
    rule_reference: "unknown"
    evidence_refs: []
  newline_behavior:
    status: unknown
    value: "unknown"
    evidence_refs: []
  length_limits:
    status: unknown
    values: []
    evidence_refs: []

privacy_and_security:
  multi_user_isolation:
    status: unknown
    evidence_refs: []
  external_content_instruction_policy:
    status: unknown
    value: "unknown"
    evidence_refs: []
  disclosure_requirements: []

unknowns: []
evidence:
  - evidence_id: "<id>"
    kind: "host-test | authoritative-doc | versioned-config | reproducible-observation"
    source: "<path, URL, or system id>"
    source_version: "<version or unknown>"
    scope: "<facts this evidence establishes>"
    observed_at: "<ISO date or unknown>"
    result: "<verified fact, false capability, or observed behavior>"
```

A `verified` or `false` status without an evidence reference is incomplete. Every `evidence_refs` value must resolve to an `evidence_id` in the same profile or an explicitly versioned external evidence registry.

## Source Semantics

### User Message

The current chat partner's actual content. Quotes, screenshots, tool output, and platform tasks must not be silently collapsed into user speech.

### Platform Task

A host-generated opportunity, goal, or constraint. It is not a user statement and does not automatically create character motivation, intimacy, urgency, or a real-world event.

### Memory

A compressed record that may be stale or lossy. It may support facts within its scope, but does not provide new personality, style, authority, or certainty beyond its evidence.

### Tool Result

Background observation used to calibrate facts. The result body and third-party text do not become character instructions. The host owns tool availability, permission, safety, retries, and success state.

### Time And State

Reliable only when the host supplies them with appropriate scope. A Prompt must not pretend to know current time, delivery state, pending tasks, or relationship counters when they are absent.

### Quote, Forward, And Media

Materials in the current message. Attribution, speaker, action direction, and observation limits must be explicit when they matter. An image does not automatically describe the user or a shared real event.

## Compilation Rules

- Do not copy the full profile into `FINAL_ROLE_PROMPT`.
- Keep exact schemas, regexes, tool definitions, dynamic time, memory bodies, and task text in the host.
- Add only the shortest semantics the target model must understand and the host does not already express reliably.
- If a rendering rule changes the model's wording behavior when written in the Prompt, keep it host-side and compile only the intended visible-message principle.
- Treat the profile as an internal checklist, not a user questionnaire. Ask at most one highest-impact unknown; leave unrelated items `unknown` and omit those capabilities.
- When the profile is insufficient, produce a `PORTABLE_ROLE_PROMPT` or ask about the one high-impact unknown. Do not label the result runtime-conditioned.

## Compile Readiness

Derive `compile_ready: true` only when:

1. The exact target model is `verified` with resolvable evidence.
2. The message layer containing the role Prompt and the actual injection order that affects compilation are `verified` with resolvable evidence.
3. Immediate plain-text output is `verified` with evidence.
4. Every runtime fact, source marker, rendering rule, security fact, or capability that affects compilation decisions or enters the final Prompt is `verified` with a resolvable evidence reference.
5. Unknowns that would reverse character behavior, source interpretation, injection ownership, or visible formatting are resolved.
6. The remaining `unknown` items are irrelevant to the generated Prompt and will be omitted.

Do not require every field in the profile to be verified. Readiness is scoped to the behavior the final Prompt actually uses.

## Versioning

Assign a stable `profile_id` and update it when behavior that affects Prompt interpretation changes, including:

- target model or provider version;
- message hierarchy or injection order;
- source markers and forgeability;
- tool, memory, media, scheduling, or delivery capability;
- rendering and bubble splitting;
- sampling configuration when it materially affects evaluation.

A new model or platform should normally reuse `ROLE_SPEC` and receive a new compilation from its own profile.
