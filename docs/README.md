# 文档索引 / Documentation Index

[返回中文首页](../README.md) | [English home](../README.en.md)

当前规范修订：`2026-09-02.4`。

每份现行规范都有独立的中文与英文文件。两个版本表达同一职责与合同；发现语义差异时，应先修正拥有该规则的规范，再同步两种语言和当前 Skill。

| 主题 | 简体中文 | English |
| --- | --- | --- |
| 架构与模型 / Prompt / 宿主边界 | [架构与职责](zh-CN/architecture.md) | [Architecture](en/architecture.md) |
| 作者侧产物、注入与生命周期 | [产物契约](zh-CN/output-contracts.md) | [Artifact Contracts](en/output-contracts.md) |
| 目标模型、平台能力与证据门槛 | [运行条件档案](zh-CN/runtime-profile.md) | [Runtime Profile](en/runtime-profile.md) |
| 静态审查、真人测试、归因与停止条件 | [评测、归因与迭代](zh-CN/evaluation-and-triage.md) | [Evaluation, Triage, And Iteration](en/evaluation-and-triage.md) |
| 早期文章、v1 归档与 companion v0 的来源和迁移 | [历史来源与方法迁移](zh-CN/migration.md) | [Historical Sources And Migration](en/migration.md) |

当前可执行入口不在 `docs/` 中：

- 中文：[role-prompt-authoring-skill.zh-CN.md](../skills/role-prompt-authoring/role-prompt-authoring-skill.zh-CN.md)
- English: [role-prompt-authoring-skill.en.md](../skills/role-prompt-authoring/role-prompt-authoring-skill.en.md)

`docs/` 用于解释和维护规范，不应与最终角色 Prompt 一起注入目标模型。
