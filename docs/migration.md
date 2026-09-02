# Migration From Historical Authoring Skills

Status: current migration guide, 2026-09-02.

Specification revision: `2026-09-02.3`.

## Historical Assets

The repository preserves two earlier bilingual methods under `archive/`:

- `persona-definition-v1`: an end-to-end persona authoring method from 2026-08-25;
- `private-chat-compilation-v0`: an experimental companion compiler from 2026-09-01.

They are evidence and migration sources, not current alternatives. Do not load either archive together with the current Role Prompt Authoring Skill.

## Why The Architecture Changed

The earlier persona Skill covered character semantics, tool behavior, platform formatting, testing, and iterative repair in one document. The companion compiler later covered natural-language creation, personality derivation, runtime adaptation, private-chat execution, compression, and failure repair.

Both therefore matched requests such as “create a role Prompt” or “make this role card more natural.” Keeping them as two public Skills would create unstable routing, duplicated rules, and unclear ownership of testing and revision.

The current method keeps the useful two-stage reasoning internally while exposing one public entry:

```text
define stable character semantics
  -> compile for known runtime conditions
  -> audit evidence before revising
```

## Mapping From Persona Definition v1

| v1 content | Current owner |
| --- | --- |
| Minimum sufficiency, personality causality, observable tendencies | Shared authoring principles and `define` |
| Identity, core personality, relationship, expression, boundaries | `ROLE_SPEC` |
| Fixed eight-section structure | Optional semantic coverage, not required headings |
| Character attitude toward uncertainty and evidence | `ROLE_SPEC` when character-specific |
| Tool availability, search triggers, permissions, citations, failure | Host and `RUNTIME_PROFILE` |
| Markdown, exact bubble regex, schemas, delivery format | Host and `RUNTIME_PROFILE` |
| Memory, tool result, quote, and platform-task source semantics | `compile`, only when the host does not already express them |
| Conflict review | Local `define` and `compile` static checks |
| Controlled testing, repeated initialization, failure repair | Shared evaluation and triage protocol |
| Default five-part delivery package | Removed; return one main artifact by route |
| Positive examples and fixed lines | Removed from final Prompt; use failure structures instead |

Do not edit the archived v1 into a “pure define” file. Preserve it for reproducibility and create current semantics from its useful principles.

## Mapping From Private Chat Compilation v0

| v0 content | Current owner |
| --- | --- |
| Natural-language user input and minimum questions | Current public entry |
| Single unified final Prompt | `compile` |
| Personality-engine derivation | `define`, not repeated inside compilation |
| Runtime capability and source semantics | `RUNTIME_PROFILE` plus minimal compiled rules |
| Character attention, motivation, private-chat action, visible compression | `compile` |
| Relationship continuity and no unsupported world invention | `define` and `compile` |
| Deletion and compression | `compile` static rules |
| Real failure categories and iteration | `audit` plus shared evaluation protocol |
| Conservative output without a runtime profile | `PORTABLE_ROLE_PROMPT`, never mislabeled final |

## Migration Procedure

### 1. Identify The Source Of Truth

Collect the user's request, reliable Canon, accepted relationship position, and the current role card. Separate platform rules, tool descriptions, examples, and dynamic context from character semantics.

### 2. Recover `ROLE_SPEC`

Extract stable identity, drives, values, tensions, attention, relationship needs and costs, expression mechanisms, boundaries, and unknowns.

Do not assume the old headings, examples, or wording must survive.

### 3. Build `PRESERVATION_MAP` When Needed

When migrating accepted text or locked design, mark accepted semantics as `must_preserve`, runtime wording as `may_adapt`, unauthorized additions as `must_not_add`, and behavior-reversing ambiguity as `unresolved`. A new character with no prior accepted text may compile directly from its accepted `ROLE_SPEC`.

### 4. Build Or Verify `RUNTIME_PROFILE`

Record exact model, provider, host, injection order, source labels, memory, tools, media, rendering, actions, and unknowns. Do not infer support from desired behavior.

### 5. Recompile From Semantic Sources

Write one Prompt from `ROLE_SPEC`, verified runtime facts, and `PRESERVATION_MAP` when applicable. Do not append the companion compiler or a generic private-chat block to the old card.

Create a minimal `BUILD_RECORD` that links the resulting Prompt version to the preserved `ROLE_SPEC`, runtime profile, and preservation map.

### 6. Validate And Triage

Perform static review, then real target-model and human validation. Route each observed failure to definition, compilation, host, model, sampling, preference, or insufficient evidence before revision.

## Portable And Final Prompts

If runtime conditions are unknown, a migrated character may receive one `PORTABLE_ROLE_PROMPT`. When runtime facts become available, replace it with one `FINAL_ROLE_PROMPT`.

Never inject both. Neither generated Prompt replaces the long-lived semantic source.

## Archive Policy

Archive files remain byte-preserved evidence. Their README files may add publication metadata, hashes, and current status, but the original Skill bodies must not be silently edited to match current behavior.
