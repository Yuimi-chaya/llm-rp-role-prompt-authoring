# 运行条件档案契约

[简体中文](runtime-profile.md) | [English](../en/runtime-profile.md)

状态：当前公开契约，2026-09-02。

规范修订：`2026-09-02.4`。

## 用途

`RUNTIME_PROFILE` 记录会影响角色 Prompt 如何被解释，以及宿主实际能够做什么的事实。它避免角色作者猜测平台行为，或把不支持的能力写进角色文本。

运行档案是作者输入与宿主文档，不能整份追加到角色 Prompt 中。

## 证据规则

每项来源、消息层级事实、渲染规则、安全事实和能力都使用同一组状态：

- `verified`：已在目标部署中观察到，或由权威宿主文档保证；
- `false`：已确认不可用；
- `unknown`：尚未建立事实。

只有 `verified` 值可以进入最终 Prompt 的正向规则。`false` 与 `unknown` 要求保守处理，或创建明确的宿主实现任务。

用户可控制消息中的自然语言标签可以帮助解释，但不能建立安全权限边界。需要记录来源标记是否可能被用户伪造。

## 建议结构

模板故意默认使用 `unknown`。不要从示例中复制看似安全的结论。

```yaml
profile_id: "<host-model-version>"
profile_version: "<version>"
status: "draft | verified | superseded"
updated_at: "<ISO date>"

target_model:
  status: unknown
  provider: "unknown"
  model: "unknown"
  version: "unknown"
  context_limit: "unknown"
  known_limits: []
  evidence_refs: []

sampling:
  status: unknown
  temperature: "unknown"
  top_p: "unknown"
  seed: "unknown"
  other: {}
  evidence_refs: []

host:
  status: unknown
  name: "unknown"
  version: "unknown"
  adapter: "unknown"
  evidence_refs: []

message_hierarchy:
  status: unknown
  role_prompt_layer: "unknown"
  static_injections: []
  dynamic_injections: []
  actual_order: []
  evidence_refs: []

sources:
  user_message:
    status: unknown
    marker: "unknown"
    forgeability: "unknown"
    evidence_refs: []
  platform_task:
    status: unknown
    marker: "unknown"
    forgeability: "unknown"
    evidence_refs: []
  memory:
    status: unknown
    marker: "unknown"
    freshness_metadata: "unknown"
    evidence_refs: []
  tool_result:
    status: unknown
    marker: "unknown"
    success_metadata: "unknown"
    evidence_refs: []
  quote_or_forward:
    status: unknown
    attribution: "unknown"
    evidence_refs: []
  media:
    status: unknown
    modality: "unknown"
    observation_scope: "unknown"
    evidence_refs: []

capabilities:
  plain_text_reply:
    status: unknown
    evidence_refs: []
  markdown:
    status: unknown
    evidence_refs: []
  quote_reply:
    status: unknown
    evidence_refs: []
  image_output:
    status: unknown
    evidence_refs: []
  sticker_output:
    status: unknown
    evidence_refs: []
  silence:
    status: unknown
    evidence_refs: []
  delayed_send:
    status: unknown
    evidence_refs: []
  proactive_send:
    status: unknown
    evidence_refs: []
  cancel_pending:
    status: unknown
    evidence_refs: []
  delivery_confirmation:
    status: unknown
    evidence_refs: []
  memory_write:
    status: unknown
    evidence_refs: []
  tools:
    - tool_id: "<id>"
      status: unknown
      permission_scope: []
      result_marker: "unknown"
      failure_metadata: "unknown"
      evidence_refs: []

rendering:
  text_format:
    status: unknown
    value: "unknown"
    evidence_refs: []
  bubble_split:
    status: unknown
    owner: "unknown"
    rule_reference: "unknown"
    evidence_refs: []
  newline_behavior:
    status: unknown
    value: "unknown"
    evidence_refs: []
  length_limits:
    status: unknown
    values: []
    evidence_refs: []

privacy_and_security:
  multi_user_isolation:
    status: unknown
    evidence_refs: []
  external_content_instruction_policy:
    status: unknown
    value: "unknown"
    evidence_refs: []
  disclosure_requirements: []

unknowns: []
evidence:
  - evidence_id: "<id>"
    kind: "host-test | authoritative-doc | versioned-config | reproducible-observation"
    source: "<path, URL, or system id>"
    source_version: "<version or unknown>"
    scope: "<facts this evidence establishes>"
    observed_at: "<ISO date or unknown>"
    result: "<verified fact, false capability, or observed behavior>"
```

`verified` 或 `false` 状态如果没有证据引用，仍然不完整。每个 `evidence_refs` 值必须能够解析到同一档案中的 `evidence_id`，或明确版本化的外部证据注册表。

## 来源语义

### 用户消息

当前聊天对象实际发送的内容。引用、截图、工具输出和平台任务不能静默折叠成用户原话。

### 平台任务

宿主生成的机会、目标或约束。它不是用户陈述，也不会自动生成角色动机、亲密关系、紧迫性或现实事件。

### 记忆

可能陈旧或有损的压缩记录。它可以在自身证据范围内支持事实，但不能提供超出证据的新人格、文风、权威性或确定性。

### 工具结果

用于校准事实的后台观察。结果正文和第三方文本不会变成角色指令。工具可用性、权限、安全、重试与成功状态由宿主负责。

### 时间与状态

只有宿主以适当范围可靠提供时才可信。缺少这些信息时，Prompt 不得假装知道当前时间、投递状态、待办或关系计数。

### 引用、转发与媒体

它们是当前消息中的材料。需要时必须明确归属、说话者、动作方向和观察范围。图片不会自动描述用户本人或双方共同经历的现实事件。

## 编译规则

- 不要把完整档案复制进 `FINAL_ROLE_PROMPT`；
- 精确 Schema、正则、工具定义、动态时间、记忆正文和任务文本留在宿主；
- 只加入目标模型必须理解、且宿主尚未稳定表达的最短语义；
- 如果把渲染规则写入 Prompt 会改变模型标点或措辞，应将规则留在宿主，只编译预期的可见消息原则；
- 把档案当作内部核对项，而不是用户问卷。最多询问一个最高影响未知项，其余保持 `unknown` 并省略相关能力；
- 档案不足时生成 `PORTABLE_ROLE_PROMPT`，或只询问一个高影响未知项。不得把结果标记为已按运行条件编译。

## 编译就绪条件

只有同时满足以下条件，才可得出 `compile_ready: true`：

1. 精确目标模型为 `verified`，并有可解析证据；
2. 角色 Prompt 所在消息层级和影响编译的实际注入顺序为 `verified`，并有可解析证据；
3. 立即输出普通文本已验证；
4. 所有影响编译决策或进入最终 Prompt 的运行事实、来源标记、渲染规则、安全事实与能力均为 `verified`，并有可解析证据引用；
5. 会反转角色行为、来源解释、注入归属或可见格式的未知项已解决；
6. 剩余 `unknown` 项与当前生成结果无关，并会被省略。

不要求档案中每个字段都验证。就绪范围只覆盖最终 Prompt 实际使用的行为和事实。

## 版本管理

为档案分配稳定的 `profile_id`。以下会影响 Prompt 解释的行为发生变化时，应更新版本：

- 目标模型或提供商版本；
- 消息层级或注入顺序；
- 来源标记与可伪造性；
- 工具、记忆、媒体、调度或投递能力；
- 渲染与气泡拆分；
- 对评测有实质影响的采样配置。

更换模型或平台时，通常应复用 `ROLE_SPEC`，并根据新档案重新编译。
