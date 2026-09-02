# 历史来源与方法迁移

[简体中文](migration.md) | [English](../en/migration.md)

状态：当前迁移指南，2026-09-02。

规范修订：`2026-09-02.4`。

## 历史资产

仓库在 `archive/` 下保存两套较早的双语方法：

- [`persona-definition-v1`](../../archive/persona-definition-v1/README.md)：公开博客文章内嵌的 2026-08-25 版本角色卡作者 Skill 的独立冻结归档；
- [`private-chat-compilation-v0`](../../archive/private-chat-compilation-v0/README.md)：2026-09-01 的实验性 companion 编译器。

它们是证据和迁移来源，不是当前可选入口。不要把任一归档与当前 Role Prompt Authoring Skill 同时加载。

Persona Definition v1 并不来自另一个独立的旧仓库。它的中文正文源于公开文章[《给 AstrBot 写人设提示词这件事,我踩过的一些坑》](https://github.com/Yuimi-chaya/Yuimi-chaya.github.io/blob/main/src/content/blog/astrbot-roleplay-persona-notes.md)中的内嵌 Skill；归档 README 另外记录了固定来源提交、文件哈希和英文配套译本的性质。文章继续由博客仓库维护，本仓库只保存可复现的 Skill 快照，不复制整篇文章。

## 为什么修改架构

较早的角色 Skill 把角色语义、工具行为、平台格式、测试与迭代修复放在同一文档中。后来的 companion 编译器又覆盖自然语言新建、人格推导、运行适配、私聊执行、压缩与失败修复。

因此，两者都会命中“创建角色 Prompt”或“让这张角色卡更自然”等请求。若保留为两个公共 Skill，会产生不稳定路由、重复规则，以及测试与修改责任不清。

当前方法保留有用的两阶段思考，但只暴露一个入口：

```text
定义稳定角色语义
  -> 按已知运行条件编译
  -> 修改前先审查证据
```

## Persona Definition v1 映射

| v1 内容 | 当前所有者 |
| --- | --- |
| 最小充分、人格因果、可观察倾向 | 共享作者原则与 `define` |
| 身份、核心人格、关系、表达、边界 | `ROLE_SPEC` |
| 固定八板块结构 | 可选语义覆盖，不再要求固定标题 |
| 角色面对未知和证据的态度 | 角色特定时进入 `ROLE_SPEC` |
| 工具可用性、搜索触发、权限、引用、失败 | 宿主与 `RUNTIME_PROFILE` |
| Markdown、精确气泡正则、Schema、投递格式 | 宿主与 `RUNTIME_PROFILE` |
| 记忆、工具结果、引用和平台任务的来源语义 | `compile`，仅在宿主未稳定表达时加入最小语义 |
| 冲突审查 | `define` 与 `compile` 的局部静态检查 |
| 控制变量、重复初始化与失败修复 | 共享评测与归因协议 |
| 默认五件套交付 | 删除；按路由只返回一个主要产物 |
| 正例与固定台词 | 从最终 Prompt 删除，改用失败结构 |

不要把归档 v1 直接修改成“纯 define”文件。应保留原件用于复现，再从有效原则建立当前语义。

## private-chat-compilation v0 映射

| v0 内容 | 当前所有者 |
| --- | --- |
| 自然语言用户输入与最少追问 | 当前公共入口 |
| 唯一统一最终 Prompt | `compile` |
| 人格引擎推导 | `define`，不在编译中重复 |
| 运行能力与来源语义 | `RUNTIME_PROFILE` 加最小编译规则 |
| 角色注意力、动机、私聊动作与可见压缩 | `compile` |
| 关系连续性与不补造世界 | `define` 与 `compile` |
| 删除与压缩 | `compile` 静态规则 |
| 真实失败分类 | 共享评测与归因协议 |
| 缺少运行档案时仍生成成品 | 改为 `PORTABLE_ROLE_PROMPT` |

## 迁移流程

### 1. 确定语义来源

识别角色事实、用户确认过的设计、原作 Canon、模型补丁、平台规则与历史示例，不把它们视为同等权威。

### 2. 恢复 `ROLE_SPEC`

从旧文本中提取身份、人格因果、关系、视角、表达和边界，删除工具 Schema、精确正则、动态状态、测试脚本与模型特定补丁。

### 3. 必要时建立 `PRESERVATION_MAP`

用户已经接受旧角色卡、存在必须保留内容，或迁移可能改变辨识度时，明确 `must_preserve`、`may_adapt`、`must_not_add` 与 `unresolved`。

### 4. 建立或验证 `RUNTIME_PROFILE`

记录目标模型、消息层级、实际注入顺序、来源、工具、记忆、媒体、渲染、动作能力及对应证据。不把 `unknown` 写成可用能力。

### 5. 从语义源重新编译

从 `ROLE_SPEC` 与档案统一重写，不拼接“旧卡 + companion + HDSI 说明 + 平台规则”。运行条件未知时只生成便携版本。

### 6. 验证与归因

先完成静态审查，再进入真实环境。观察失败先归因，只修改拥有该问题的语义源、运行档案或编译规则。

## 便携与最终 Prompt

运行事实未知时，迁移后的角色可以得到一个 `PORTABLE_ROLE_PROMPT`。运行事实满足证据门槛后，用一个 `FINAL_ROLE_PROMPT` 替换它。

绝不能同时注入两者。任何生成 Prompt 都不能替代长期角色语义源。

## 归档政策

归档文件保持原字节。README 可以增加发布元数据、哈希和当前状态，但不得静默修改原 Skill 正文，使其看起来符合当前行为。
