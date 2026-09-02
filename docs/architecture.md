# Architecture And Responsibility Boundaries

Status: current public architecture, 2026-09-02.

Specification revision: `2026-09-02.4`.

## Scope

This repository defines an authoring method for realistic one-to-one direct-message role Prompts. It covers character definition, runtime-conditioned Prompt compilation, and evidence-based diagnosis.

It does not implement a host runtime, persistent world, tool system, scheduler, memory database, media pipeline, or delivery service.

## One Public Entry

The only current entry is one language version of the Role Prompt Authoring Skill under `skills/role-prompt-authoring/`.

`define`, `compile`, and `audit` are internal modes of that entry. They are not separate public Skills and are not three Prompts that a user must concatenate or invoke manually.

```text
ordinary user request
  -> one authoring entry
     -> define character semantics when needed
     -> compile for known runtime conditions when possible
     -> audit real failures before revision
  -> one main artifact for the current request
  -> non-injectable build provenance retained separately
```

## Three Responsibility Layers

### Model Layer

The model layer determines the capability ceiling:

- instruction following;
- multimodal pragmatics;
- long-context stability;
- reasoning and ambiguity handling;
- sampling variance.

A Prompt can improve probability and reduce conflict. It cannot guarantee behavior the model is unable to understand or follow.

### Prompt Layer

The Prompt layer owns:

- identity, Canon, personality causality, relationship, and expression;
- attention and interpretation tendencies;
- private-chat interaction measure and visible expression;
- minimum host semantics the target model must understand;
- soft boundaries against common Prompt-side failure patterns.

It does not own persistent truth, actual tool execution, or delivery state.

### Host Layer

The host layer owns:

- source identity and message authority;
- current time, state, memory, and retrieval;
- tool availability, permissions, execution, and failure;
- media packaging and observation scope;
- scheduling, silence, delay, proactive sending, cancellation, retry, and delivery confirmation;
- rendering, bubble splitting, quoting, and transport behavior.

When the host does not provide a reliable fact or capability, the Prompt may preserve uncertainty but cannot manufacture the missing guarantee.

## Canonical Documents

Each public document has one responsibility:

| Document | Owns | Must Not Become |
| --- | --- | --- |
| `README.md` | Product discovery, current entry, repository map, publication status | A second Skill specification |
| `skills/role-prompt-authoring/*.md` | The executable authoring workflow | A host runtime manual |
| `docs/architecture.md` | Responsibility boundaries and public information architecture | A full evaluation protocol |
| `docs/output-contracts.md` | Artifact names, ownership, lifecycle, and injection rules | A role-writing tutorial |
| `docs/runtime-profile.md` | Runtime fact schema and evidence requirements | Platform implementation code |
| `docs/evaluation-and-triage.md` | Testing, attribution, iteration, and stopping rules | A benchmark leaderboard |
| `docs/migration.md` | Mapping historical artifacts to the current workflow | A duplicate current Skill |
| `archive/` | Historical evidence and reproducibility | An active entry point |

If two documents appear to own the same rule, move the detailed rule to the owner above and leave only a short pointer elsewhere.

The maintainer documents above are normative sources. The bilingual Skill files are synchronized standalone release artifacts derived from this specification. When a conflict is found, resolve it in the owning document, update the specification revision, then update both Skill languages and routing tests together.

## Authoring Pipeline

```text
USER_INTENT + CANON
  -> ROLE_SPEC

ROLE_SPEC
  -> PORTABLE_ROLE_PROMPT, when runtime is unknown

ROLE_SPEC + compile-ready RUNTIME_PROFILE
  + PRESERVATION_MAP, when rewriting accepted text
  -> FINAL_ROLE_PROMPT

EVIDENCE_RECORD
  -> TRIAGE_RESULT
  -> revise the owning source only when evidence is sufficient

every prompt build
  -> BUILD_RECORD, retained outside the target Prompt
```

The final Prompt is a build artifact. Future iterations should return to the accepted semantic and runtime sources instead of endlessly patching the last generated text.

“One main artifact” means one user-facing result and one injected role Prompt, not one total authoring file. A production workflow must persist the versioned `ROLE_SPEC` and a minimal `BUILD_RECORD`. In a chat-only environment without persistence, a `ROLE_SPEC` snapshot and the build record are returned as clearly separated non-injectable authoring sidecars.

## Private-Chat Execution Principles

The compilation stage may distill these principles into character-specific wording:

- Distinguish user speech from platform tasks, memory, tool output, quotes, and media.
- Separate confirmed facts, plans, guesses, temporary state, and unknowns.
- Let character perspective and motivation decide what matters now.
- Treat the output as one real send action rather than a complete answer document.
- Suppress visible-delivery bias: the model need not prove understanding through restatement, analysis, advice, or follow-up.
- Preserve incomplete meaning: a sticker, symbol, fragment, or layered meme may function as tone, rhythm, or presence without one fully resolved proposition.
- Let stable personality and relationship change only through sustained evidence.

These are authoring principles, not a per-turn algorithm or hidden chain-of-thought requirement.

## Public Repository Boundary

This public candidate is built from an explicit allowlist and does not inherit the private research repository's Git history.

The initial tree excludes real deployment iterations, real chat, internal recovery notes, benchmark work files, and private configuration. Those materials require separate authorization, privacy, licensing, and necessity review before publication.

## Claims

Valid claims are limited to controlled, relative changes under the same exact model, provider version, host, injection semantics, tools, memory, media pipeline, context, sampling configuration, and user input.

Do not claim that this method:

- makes arbitrary models human;
- eliminates OOC behavior;
- reproduces a host-authoritative framework through one Prompt;
- provides capabilities absent from the host;
- generalizes from one sample, one character, or one evaluator preference.
