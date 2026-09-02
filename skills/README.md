# 当前 Skill / Current Skill

## 简体中文

当前只使用 `role-prompt-authoring/` 中的一种语言版本：

- `role-prompt-authoring/role-prompt-authoring-skill.zh-CN.md`
- `role-prompt-authoring/role-prompt-authoring-skill.en.md`

两份文件表达同一作者工作流，是直接提供给提示词编写模型的独立 Markdown，不是 Codex 安装格式的 `SKILL.md`。不要同时加载两种语言，也不要与 `archive/` 下的历史 Skill 混用。

当前 Skill 内部路由 `define`、`compile` 与 `audit`，但只返回用户当前需要的主要产物：`ROLE_SPEC`、按需生成的 `PORTABLE_ROLE_PROMPT`、`FINAL_ROLE_PROMPT`、`TRIAGE_RESULT` 或 `EVALUATION_PLAN`。

运行时只能使用一个角色 Prompt。便携版本与最终版本不能同时注入；每次构建另行保留的 `BUILD_RECORD` 只是不可注入的溯源附件。

## English

Use exactly one language version from `role-prompt-authoring/`:

- `role-prompt-authoring/role-prompt-authoring-skill.zh-CN.md`
- `role-prompt-authoring/role-prompt-authoring-skill.en.md`

Both files describe the same authoring workflow. They are standalone Markdown prompts for a Prompt-writing model, not Codex-installable `SKILL.md` packages. Do not load both languages or combine a current file with archived Skills.

The Skill internally routes among `define`, `compile`, and `audit`, while returning only the main artifact needed now: `ROLE_SPEC`, an optional `PORTABLE_ROLE_PROMPT`, `FINAL_ROLE_PROMPT`, `TRIAGE_RESULT`, or `EVALUATION_PLAN`.

A target runtime uses one role Prompt. Portable and final builds are never injected together; the separately retained `BUILD_RECORD` is non-injectable provenance.
