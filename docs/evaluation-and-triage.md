# Evaluation, Triage, And Iteration Protocol

Status: current shared protocol, 2026-09-02.

## Purpose

This is the single owner of testing, failure attribution, revision, regression, and Prompt-only stopping rules.

Do not duplicate a full testing workflow inside both role definition and compilation. Those stages perform only their local static checks and route real evidence here.

## Evaluation Layers

### 1. Definition Review

Review `ROLE_SPEC` without requiring a target platform:

- identity and Canon are reliable within the selected scope;
- personality traits are tied to drives, values, sensitivity, defenses, and repair;
- relationship position, costs, boundaries, and gradual change are coherent;
- expression follows personality rather than fixed lines or generic labels;
- user preference is distinguished from necessary character behavior;
- unknowns and conflicting versions remain visible;
- platform tools, regexes, dynamic state, and model patches have not entered the semantic source.

Failure returns to `define`.

### 2. Compilation Review

Review `FINAL_ROLE_PROMPT` against `ROLE_SPEC`, `PRESERVATION_MAP`, and `RUNTIME_PROFILE`:

- one target Prompt exists;
- `must_preserve` is retained and `must_not_add` is respected;
- the runtime profile is sufficient for a conditioned claim;
- unsupported capabilities are absent;
- exact host schema, regex, dynamic context, and duplicated injections are absent;
- authoring assets, research terms, scoring, and per-turn algorithms are absent;
- private-chat behavior is character-specific rather than a universal short-reply template;
- Prompt length reflects necessary decisions rather than accumulated repairs.

Failure returns to `compile` or the runtime profile owner.

### 3. Real Integration And Human Validation

Test in the actual target environment. Fix:

- exact model and provider version;
- host and message hierarchy;
- system injection order;
- tools, memory, media pipeline, and rendering;
- context and opening state;
- sampling parameters and user input.

Change only the Prompt or authoring method under evaluation.

Assess observable behavior rather than asking whether the model can repeat written rules. Natural test messages should resemble real direct messaging and include ordinary ambiguity, casual fragments, topic changes, emotion, media, disagreement, and natural silence in realistic proportions.

Avoid trajectories that repeatedly test search, injection, boundaries, or explicitly documented persona facts. Such tests measure instruction retrieval and may overfit the Prompt rather than evaluate ordinary interaction.

### 4. Capability Audit

Verify that time, state, source identity, tools, media, delay, proactive sending, cancellation, memory, and delivery are actually provided by the host.

Failure returns to the host. Do not add a role rule to simulate a missing implementation guarantee.

## Observable Failure Taxonomy

### Definition Failures

- vague or interchangeable personality;
- contradictory drives or boundaries;
- incorrect Canon or relationship position;
- expression that cannot be traced to personality;
- user preference presented as unavoidable character behavior.

### Compilation Failures

- assistant voice during ordinary social chat;
- visible-delivery bias: restatement, explanation, advice, praise, comfort, or questions appended to prove understanding;
- semantic-closure bias: forcing fragments, stickers, or memes into one complete old-topic proposition;
- relationship jumps, promises, or care workflows without sufficient evidence;
- mechanical bubble counts, fixed tiny replies, or repeated surface catchphrases;
- source confusion among user, platform task, memory, tools, quotes, and media;
- Prompt growth, duplicated rules, or model-facing authoring terminology.

### Host Failures

- mixed or forgeable source labels treated as authority;
- missing or stale state presented as current truth;
- unsupported silence, delay, active sending, cancellation, or delivery confirmation;
- media direction and attribution lost during packaging;
- rendering or bubble splitting that changes the visible message unexpectedly.

### Non-Prompt Causes

- model instruction-following or multimodal limit;
- sampling variance;
- evaluator preference that conflicts with accepted character logic;
- insufficient evidence or one-off output.

## Evidence Record

Before revising, record the minimum evidence described in `output-contracts.md`:

- exact conditions;
- actual visible input;
- expected and observed behavior;
- specific failure signal;
- reproduction count and evidence strength;
- one primary hypothesis.

Use redacted excerpts. Do not store credentials or unnecessary private conversation.

## Triage

Return one primary category:

```text
definition_fault
compilation_fault
host_contract_fault
model_limit
sampling_variance
preference_mismatch
insufficient_evidence
```

Multiple contributing factors may be noted, but the next iteration tests one primary hypothesis. This preserves causal attribution.

## Revision Rules

1. Change the owning source: `ROLE_SPEC`, `RUNTIME_PROFILE`, or compiler rule.
2. Rebuild the Prompt artifact; do not rely on direct patches to the last output.
3. Make only changes supported by observed evidence.
4. Preserve accepted Canon, personality, relationship, expression, and boundaries unless the user authorizes a change.
5. Do not convert one good or bad sample into a universal rule.
6. Prefer deletion, clearer ownership, and simpler priority over another exception.
7. Record version, hypothesis, changed source, environment, result, and whether the observation is author-reviewed, model-tested, or human-validated.

## Regression

After a fix, rerun:

- the smallest case that reproduced the failure;
- ordinary unaffected chat cases;
- source-boundary cases relevant to the change;
- at least one independent new session when routing variance is plausible.

Do not declare success merely because the exact wording of a test case changed. Check whether the underlying failure structure decreased without creating coldness, random neglect, fixed short replies, or lost character identity.

## Prompt-Only Stop Conditions

Stop adding Prompt rules when:

- the missing requirement belongs to host state, source, tools, time, media, scheduling, or delivery;
- the same clear rule still fails because of model capability;
- new rules mostly restate existing rules or repair low-probability examples;
- improvements in one case repeatedly create regressions in ordinary chat;
- only single-sample or preference evidence remains;
- Prompt complexity has become a larger source of failure than the original problem.

At that point, choose a different model, change host implementation, adjust sampling, gather stronger evidence, or accept the remaining variance.

## Reporting Claims

Report only:

- exact model and host conditions;
- Prompt and runtime profile versions;
- what changed;
- which observable failures decreased or increased;
- repetition count and human-validation status;
- remaining model and host limitations.

Do not combine definition-quality improvement and runtime-compilation improvement into one universal Skill score. Do not compare absolute scores across different models or platforms as if they measured the same Prompt effect.
