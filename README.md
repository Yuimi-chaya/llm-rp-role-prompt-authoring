# LLM RP Role Prompt Authoring

> 本仓库当前是 **2026-09-02 的本地预发布草案**，尚未公开发布，也尚未选择许可证。

这是一个面向现实一对一私聊的角色 Prompt 作者侧方法。它帮助提示词编写模型或人工作者，从普通用户的自然需求出发，建立稳定角色定义，再结合确定的模型与宿主条件，生成唯一可部署的角色 Prompt。

本项目不承诺让任意模型“变成真人”，也不试图用更长的角色卡替代宿主的时间、记忆、工具、状态、调度、媒体和投递能力。目标是在**同一模型、同一宿主和相同输入条件下**，减少角色定义冲突、助手化、展示性交付、关系跃迁、来源误读和过度完整等可由 Prompt 侧影响的失败。

## 当前入口

普通用户和提示词编写模型只应使用一个当前入口：

- 中文：[role-prompt-authoring-skill.zh-CN.md](skills/role-prompt-authoring/role-prompt-authoring-skill.zh-CN.md)
- English: [role-prompt-authoring-skill.en.md](skills/role-prompt-authoring/role-prompt-authoring-skill.en.md)

它们是可直接提供给提示词编写模型的**单文件作者 Skill**，不是 Codex 安装目录格式，也不是要与最终角色 Prompt 一起注入目标聊天模型的第二张角色卡。

## 它如何工作

Skill 内部有三个模式，但用户不需要手工选择或连续调用三份文件：

| 模式 | 解决的问题 | 主要产物 |
| --- | --- | --- |
| `define` | 角色是谁，为什么这样理解、在意和表达 | `ROLE_SPEC` 或按需生成的 `PORTABLE_ROLE_PROMPT` |
| `compile` | 在确定模型与宿主中怎样更稳定地表现成自己 | `FINAL_ROLE_PROMPT` |
| `audit` | 真人失败属于定义、编译、宿主、模型、采样还是偏好 | `TRIAGE_RESULT` |

从零创建且运行条件已知时，入口会在内部完成 `define -> compile`，默认只交付一份 `FINAL_ROLE_PROMPT`。用户不会先收到一张通用角色卡，再收到第二张“拟人化补丁”。

## 快速使用

1. 选择中文或英文 Skill 文件，把其全文提供给负责写 Prompt 的模型。
2. 用普通语言描述角色、用途、关系、希望保留的气质和讨厌的表现。
3. 若已经确定部署环境，补充模型精确型号、平台、消息注入、工具、记忆、媒体和渲染条件。
4. 若正在返工，提供脱敏的真实失败样本，而不是只说“感觉不对”。
5. 默认只取当前任务需要的一个主要产物；不要把作者侧分析、运行档案或验收记录注入目标聊天模型。

详细接口见：

- [架构与职责](docs/architecture.md)
- [作者侧产物契约](docs/output-contracts.md)
- [运行条件档案](docs/runtime-profile.md)
- [评测、归因与迭代](docs/evaluation-and-triage.md)
- [从旧版迁移](docs/migration.md)

## 仓库结构

```text
README.md
NOTICE.md
skills/
  README.md
  role-prompt-authoring/
    README.md
    role-prompt-authoring-skill.zh-CN.md
    role-prompt-authoring-skill.en.md
docs/
  architecture.md
  output-contracts.md
  runtime-profile.md
  evaluation-and-triage.md
  migration.md
archive/
  README.md
  persona-definition-v1/
  private-chat-compilation-v0/
tests/
  routing-cases.md
scripts/
  validate-release.ps1
```

`archive/` 保存历史方法和实验原型，仅用于研究、迁移和复现。它们不是当前入口，也不应与当前 Skill 同时交给提示词编写模型。

## 首发白名单

本地公开候选仓库只跟踪上面的作者 Skill、规范、归档原件、测试用例和验证脚本。以下材料暂不进入首发公开树：

- 真实 AstrBot 部署提示词和真人迭代记录；
- 内部开发恢复笔记；
- benchmark 运行日志、无效尝试和评审工作文件；
- 密钥、账号、私有配置、真实聊天和任何未授权资料。

这些材料即使对研究有价值，也必须经过逐项授权、脱敏、许可和必要性审查后，才能作为独立 case study 或 evidence package 加入。

## 效果边界

有效比较必须固定模型、提供商版本、宿主、系统注入、工具、记忆、媒体链路、上下文、采样参数和用户输入，只改变 Prompt 或编译方法。不同模型、不同平台或单次随机采样之间的绝对差异不能归因给本 Skill。

Prompt 可以改变行为概率和减少冲突，但不能凭空提供：

- 可信来源标签和持久状态；
- 真实时间、日程、延迟和主动发送；
- 工具执行、权限、安全校验和投递确认；
- 多用户隔离、并发取消和长期记忆管理。

## 发布状态与许可证

当前没有 `LICENSE`。在仓库所有者选择适用于代码、文档、Prompt 和归档材料的许可证，并完成第三方内容与隐私复核前，本仓库只是本地发布候选，不能宣称已经完成开源发布。

## English Summary

This is a local pre-release repository for a single-entry role prompt authoring method. Use one language-specific standalone Skill file from `skills/role-prompt-authoring/`. Internally it routes between role definition, runtime-conditioned compilation, and evidence-based audit, while producing only the artifact needed for the current request. Historical files under `archive/` are not active entry points. No license has been selected yet.
