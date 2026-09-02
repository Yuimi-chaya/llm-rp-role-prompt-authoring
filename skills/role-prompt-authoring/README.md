# Role Prompt Authoring Skill

状态 / Status：`2.0.0-draft.4`，规范修订 / specification revision `2026-09-02.4`，公开草案 / public draft。该版本不宣称为稳定 `2.0.0` / this version does not claim to be stable `2.0.0`.

## 简体中文

选择一个文件：

- 中文：`role-prompt-authoring-skill.zh-CN.md`
- English：`role-prompt-authoring-skill.en.md`

把其中一份完整提供给负责创建或修改角色 Prompt 的模型。它们是作者 Skill，不是运行时角色 Prompt。

适用请求：从自然语言建立角色定义；为已验证模型与私聊宿主生成条件化 Prompt；把可信角色迁移到另一模型或平台；修改前诊断真实聊天失败。

不负责：实现工具、记忆、时间、调度、投递或平台代码；优化与 RP 无关的通用 Prompt；默认续写共同世界剧情；在没有目标模型测试和真人验收时保证自然效果。

默认只展示用户要求的主要产物。便携或最终构建还必须保留不可注入的 `BUILD_RECORD`；目标部署只能包含一个角色 Prompt。

中文维护文档见 `../../docs/zh-CN/`。

## English

Choose one file:

- Chinese: `role-prompt-authoring-skill.zh-CN.md`
- English: `role-prompt-authoring-skill.en.md`

Provide one complete file to the model responsible for creating or revising a role Prompt. These are authoring Skills, not runtime character Prompts.

Use them to create character semantics from ordinary language, compile for a verified model and private-chat host, migrate a trusted character, or diagnose real chat failures before revision.

They do not implement tools, memory, time, scheduling, delivery, or platform code; optimize unrelated general Prompts; assume shared-world narrative continuation; or guarantee natural behavior without target-model and human validation.

Expose only the main artifact requested by the user. Portable or final builds also retain a non-injectable `BUILD_RECORD`; a target deployment contains exactly one role Prompt.

English maintainer documentation lives under `../../docs/en/`.
