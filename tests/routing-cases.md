# Role Prompt Authoring Routing Cases

Status: pre-release acceptance cases, 2026-09-02.

These cases test whether the single public Skill selects the correct internal mode and returns one appropriate main artifact. They do not evaluate the final role's chat quality.

## Acceptance Rule

For each case, use one language version of the current Skill in a fresh prompt-writing session. The writer may ask only high-impact questions allowed by the Skill. It must not expose all internal assets or return multiple prompt candidates by default.

## Positive Routing Cases

| ID | User request summary | Expected route | Expected main artifact | Must not happen |
| --- | --- | --- | --- | --- |
| R01 | “帮我设计一个嘴硬但很重感情的原创角色，先把人物底层逻辑写清楚。” | `define` | `ROLE_SPEC` | Generate a platform-bound Prompt |
| R02 | “帮我生成用于 LLM RP 的某角色提示词。” No model or platform given | `define` | `PORTABLE_ROLE_PROMPT` | Claim runtime-conditioned optimization |
| R03 | Same as R02, but exact model and QQ private-chat host are provided | `define -> compile` | `FINAL_ROLE_PROMPT` | Return a portable card plus a second patch |
| R04 | Existing role card is trusted; user moves from one model to another | `compile` | `FINAL_ROLE_PROMPT` | Redesign Canon or relationship without evidence |
| R05 | Existing card contradicts itself about identity and relationship | `audit -> define` | `TRIAGE_RESULT` or one definition repair artifact | Patch only wording while preserving the contradiction |
| R06 | User provides a real chat where the model restates a meme and adds advice | `audit` | `TRIAGE_RESULT` | Rewrite the whole Prompt before attribution |
| R07 | User asks only how a host should mark memory, tool output, and platform tasks | host/runtime boundary | Runtime guidance, not a role Prompt | Enter `define` or invent a character |
| R08 | User asks for a controlled test plan for two Prompt versions | evaluation boundary | Test plan | Generate a new role Prompt |
| R09 | User provides a stable character and a verified native multimodal runtime | `compile` | `FINAL_ROLE_PROMPT` | Add an obsolete image-captioning sub-model requirement |
| R10 | User asks to migrate a realistic private-chat role into shared-world story continuation | explicit scope clarification | Clarification or unsupported-mode boundary | Silently keep realistic private-chat assumptions |
| R11 | User says only “优化一下，更像真人” and gives no sample or target condition | static review or minimum clarification | Review/clarification | Treat personal taste as proven compilation failure |
| R12 | User provides one odd sample from a high-variance model | `audit` | `TRIAGE_RESULT` with `sampling_variance` or `insufficient_evidence` | Add a universal rule from one sample |

## Artifact Checks

### `ROLE_SPEC`

- Contains character semantics, not platform regexes or tool implementation.
- Makes unknowns and relationship position explicit.
- Does not claim to be the deployment Prompt unless the user requested a portable build.

### `PORTABLE_ROLE_PROMPT`

- States outside the Prompt body that it is not runtime-conditioned.
- Assumes only immediate plain-text output.
- Does not promise tools, memory, media, delay, proactive sending, or delivery confirmation.
- Is the only proposed temporary injected role Prompt.

### `FINAL_ROLE_PROMPT`

- Is one unified Prompt rather than an old card plus an appended module.
- Does not expose `ROLE_SPEC`, `RUNTIME_PROFILE`, modes, evaluation, HDSI, or authoring analysis.
- Does not duplicate exact host schemas, regexes, or dynamic content.
- Preserves accepted Canon and character identity.

### `TRIAGE_RESULT`

- Names one primary responsibility category.
- States evidence strength and one testable hypothesis.
- Routes the next action without automatically authorizing a Prompt rewrite.

## Negative Selection Checks

The current Skill must not activate as the main solution for:

- general software prompts unrelated to roleplay;
- platform plugin implementation;
- memory database or scheduler design;
- generic fiction continuation;
- requests to bypass higher-level safety or platform rules;
- claims that a single Prompt can provide real tools, time, delivery, or persistent state.

## Bilingual Parity Review

Run at least R02, R03, R06, R07, R10, and R12 against both language files. Equivalent requests must select the same route and artifact category. Exact wording may differ; ownership, boundaries, and output count must not.
