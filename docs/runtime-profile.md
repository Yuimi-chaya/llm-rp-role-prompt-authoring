# Runtime Profile Contract

Status: current public contract, 2026-09-02.

## Purpose

`RUNTIME_PROFILE` records facts that determine how a role Prompt is interpreted and what the host can actually do. It prevents role authors from guessing platform behavior or encoding unsupported capabilities into character text.

The profile is authoring input and host documentation. It is not appended wholesale to the role Prompt.

## Evidence Rule

Every capability must be one of:

- `verified`: observed in the target deployment or guaranteed by authoritative host documentation;
- `false`: confirmed unavailable;
- `unknown`: not established.

Only `verified` capabilities may generate positive behavior rules. `false` and `unknown` require conservative behavior or an explicit host implementation task.

Natural-language labels inside a user-controlled message may help interpretation but do not create a secure authority boundary. Record whether a source marker can be forged by the user.

## Suggested Schema

```yaml
profile_id: "<host-model-version>"
status: "draft | verified | superseded"
updated_at: "<ISO date>"

target_model:
  provider: "<provider>"
  model: "<exact model id>"
  version: "<provider/model version if known>"
  context_limit: "<known or unknown>"
  known_limits: []

sampling:
  temperature: "<value or unknown>"
  top_p: "<value or unknown>"
  seed: "<value, unsupported, or unknown>"
  other: {}

host:
  name: "<host/framework>"
  version: "<version>"
  adapter: "<transport/adapter>"

message_hierarchy:
  role_prompt_layer: "<system/developer/user-equivalent>"
  static_injections: []
  dynamic_injections: []
  actual_order: []

sources:
  user_message:
    marked: true
    forgeable: false
  platform_task:
    present: false
    marked: false
    forgeable: unknown
  memory:
    present: false
    marked: false
    freshness_metadata: false
  tool_result:
    present: false
    marked: false
    success_metadata: false
  quote_or_forward:
    present: false
    attribution: unknown
  media:
    present: false
    modality: "none | description | native-multimodal"
    observation_scope: "<scope or unknown>"

capabilities:
  plain_text_reply: verified
  markdown: unknown
  quote_reply: unknown
  image_output: false
  sticker_output: false
  silence: false
  delayed_send: false
  proactive_send: false
  cancel_pending: false
  delivery_confirmation: false
  memory_write: false
  tools: []

rendering:
  text_format: "plain | markdown | mixed | unknown"
  bubble_split_owner: "host | model | unknown"
  bubble_split_rule: "<reference, not necessarily full regex>"
  newline_behavior: "<behavior or unknown>"
  length_limits: []

privacy_and_security:
  multi_user_isolation: unknown
  external_content_is_instruction: false
  disclosure_requirements: []

unknowns: []
evidence: []
```

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
- When the profile is insufficient, produce a `PORTABLE_ROLE_PROMPT` or stop and ask about the one high-impact unknown. Do not label the result runtime-conditioned.

## Versioning

Assign a stable `profile_id` and update it when behavior that affects Prompt interpretation changes, including:

- target model or provider version;
- message hierarchy or injection order;
- source markers and forgeability;
- tool, memory, media, scheduling, or delivery capability;
- rendering and bubble splitting;
- sampling configuration when it materially affects evaluation.

A new model or platform should normally reuse `ROLE_SPEC` and receive a new compilation from its own profile.
