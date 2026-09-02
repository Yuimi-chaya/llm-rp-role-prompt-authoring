# 作者侧产物契约

[简体中文](output-contracts.md) | [English](../en/output-contracts.md)

状态：当前公开契约，2026-09-02。

规范修订：`2026-09-02.4`。

## 用途

这些契约用于防止角色语义、运行事实、失败证据和可部署 Prompt 混成一份无法追溯的文档。

下面的名称是作者侧接口，绝不能出现在可部署角色 Prompt 正文中。它们只能出现在 Prompt 之外的作者讨论与记录里。

## 产物表

| 产物 | 所有者 | 主要用途 | 可注入 |
| --- | --- | --- | --- |
| `ROLE_SPEC` | `define` | 稳定、可复用的角色语义 | 否 |
| `PRESERVATION_MAP` | `compile` | 重写时保护已接受设计 | 否 |
| `RUNTIME_PROFILE` | 宿主维护者 / 部署者 | 已验证运行事实与未知项 | 否 |
| `EVIDENCE_RECORD` | 测试者 / 真人评审 | 可复现的失败证据 | 否 |
| `PORTABLE_ROLE_PROMPT` | `define` 构建 | 没有固定运行环境时的可用基线 | 是，只能作为唯一临时 Prompt |
| `FINAL_ROLE_PROMPT` | `compile` 构建 | 按运行条件编译的部署 Prompt | 是，唯一最终 Prompt |
| `TRIAGE_RESULT` | `audit` | 责任层、证据强度、假设与下一步 | 否 |
| `EVALUATION_PLAN` | `audit` 规划路径 | 受控测试或回归计划 | 否 |
| `BUILD_RECORD` | 作者工作流 | 最小构建溯源与验证状态 | 否 |
| `NON_INJECTABLE_MANIFEST` | 作者工作流 | 版本、假设、删改和能力缺口 | 否 |

`PORTABLE_ROLE_PROMPT` 与 `FINAL_ROLE_PROMPT` 绝不能同时注入。

## `ROLE_SPEC`

`ROLE_SPEC` 是长期存在的角色语义源。除非用户修改角色本身，否则更换模型或平台时它应保持稳定。

推荐字段：

```yaml
role_id: "<stable identifier>"
role_spec_version: "<version>"
canon_scope:
  source: "<source or user-defined>"
  version: "<version or unknown>"
  facts: []
  unknowns: []
identity: "<who the character is>"
relationship:
  position: "<current relationship>"
  needs: []
  costs: []
  gradual_changes: []
personality:
  drives: []
  value_order: []
  tensions: []
  sensitivities: []
  defenses: []
  repair_patterns: []
perspective:
  attention_biases: []
  interpretation_tendencies: []
expression:
  inner_outer_gap: []
  directness: "<range>"
  information_density: "<how it changes>"
  humor_and_teasing: []
boundaries:
  allowed: []
  disallowed: []
  absolute_red_lines: []
unresolved: []
```

该结构只是示意，不要求普通用户填写表单。作者模型可以在内部维护，只展示用户要求的内容。

`ROLE_SPEC` 不得包含精确工具 Schema、平台正则、动态记忆、当前时间或模型特定补丁。

## `PRESERVATION_MAP`

重写已接受的角色卡、迁移已接受设计或遵守用户明确锁定内容前，先建立：

```yaml
preservation_map_version: "<version>"
must_preserve: []
may_adapt: []
must_not_add: []
unresolved: []
```

- `must_preserve`：已接受的 Canon、人格机制、关系位置、辨识度表达与红线。
- `may_adapt`：目标运行环境要求的措辞、顺序、显式程度与压缩方式。
- `must_not_add`：未授权世界事实、共同历史、关系事实、能力和固定台词。
- `unresolved`：可能反转行为的歧义，必须澄清或继续保持不确定。

删除或改变 `must_preserve` 项，必须获得用户明确授权，或有证据证明已接受来源本身有误。

全新角色没有已接受旧文本时，`ROLE_SPEC` 已经足够；不要只为满足流程创建空表。

## `RUNTIME_PROFILE`

`RUNTIME_PROFILE` 是模型与宿主事实的唯一公开契约。结构和证据规则见 `runtime-profile.md`。

它必须区分已验证能力、不存在的能力和未知能力。`unknown` 不等于允许承诺支持。

## `EVIDENCE_RECORD`

推荐字段：

```yaml
record_id: "<id>"
evidence_basis: "runtime | static"
role_version: "<ROLE_SPEC version>"
prompt_version: "<portable or final version>"
runtime_profile_id: "<id or unknown>"
subject_ref: "<reviewed file, text id, or none>"
subject_hash: "<hash or none>"
conditions:
  model: "<exact model>"
  provider: "<provider/version>"
  sampling: "<relevant settings>"
  context: "<relevant injection and history>"
user_input: "<redacted exact input>"
expected_behavior: "<observable expectation>"
observed_behavior: "<observable result>"
failure_signal: "<specific behavior>"
reproduction:
  independent_sessions: 0
  repeated: false
evidence_strength: "single-sample | suggestive | repeated | human-validated"
primary_hypothesis: "<one hypothesis>"
privacy_notes: []
```

静态审查使用 `subject_ref` 与 `subject_hash`，设置 `observed_behavior: none`、`reproduction: not-applicable`。确实不适用的运行字段可以写 `none`，不得为静态发现虚构聊天证据。

最小脱敏摘录足够时，不要保存凭据、不必要的个人信息或完整私聊。

## `PORTABLE_ROLE_PROMPT`

用户想要可用 Prompt，但尚未确定目标模型与宿主时使用。

要求：

- 从已接受的 `ROLE_SPEC` 构建；
- 只采用“能够立即输出普通文本”的保守假设；
- 不承诺工具、记忆、媒体、延迟、主动发送、引用或投递确认；
- 在 Prompt 正文之外明确标注尚未按运行条件编译；
- 可以作为唯一临时角色 Prompt；
- 编译完成后由 `FINAL_ROLE_PROMPT` 替换，而不是叠加。

它是构建产物。只修改该文本不能改变权威角色定义。

## `FINAL_ROLE_PROMPT`

只有存在 `compile_ready` 的 `RUNTIME_PROFILE` 时才使用。

`compile_ready` 表示：

- 精确目标模型、角色 Prompt 消息层级和影响编译的实际注入顺序均为 `verified`，并具有可解析证据；
- 立即输出普通文本已验证；
- 所有影响编译决策或进入最终 Prompt 的运行事实、来源标记、渲染规则、安全事实与能力均已验证并有可解析引用；
- 会反转角色行为、来源解释或可见格式的未知项已解决；
- 无关能力可以保持 `unknown`，但必须省略。

要求：

- 在不可注入记录中标识本次构建的 `ROLE_SPEC` 版本和 `runtime_profile_id`，不写入 Prompt 正文；
- 存在保留映射时，保留 `must_preserve` 并遵守 `must_not_add`；
- 只包含目标模型需要的最小运行语义；
- 不重复精确 Schema、正则、动态上下文或更高层平台注入；
- 不包含作者工作流、评测标准、研究术语或未支持能力；
- 是目标部署唯一角色 Prompt。

`FINAL` 只表示本次、该运行条件下的唯一最终构建物，不表示已经真人验收或无条件生产稳定。

## `TRIAGE_RESULT`

推荐字段：

```yaml
triage_id: "<id>"
evidence_record_id: "<id>"
affected_versions:
  role_spec_version: "<version>"
  prompt_version: "<version>"
  runtime_profile_id: "<id or unknown>"
responsible_layer: "definition_fault | compilation_fault | host_contract_fault | model_limit | sampling_variance | preference_mismatch | insufficient_evidence"
evidence_basis: "static | single-sample | repeated-runtime | human-validated"
evidence_strength: "<level>"
primary_hypothesis: "<one testable hypothesis>"
supporting_observations: []
excluded_causes: []
next_action: "<define | compile | host | model/config | repeat | clarify>"
prompt_change_authorized: false
```

`audit` 不得静默把 `prompt_change_authorized` 改成 `true`。证据必须支持 Prompt 侧失败，并且用户确实要求修改。

证据不完整时，`TRIAGE_RESULT` 可以是暂定结论，但仍需标明证据强度，并且最多请求一个最能区分候选原因的补充事实。

## `EVALUATION_PLAN`

用户要求测试或回归设计，而不是新角色 Prompt 时使用。

推荐字段：

```yaml
plan_id: "<id>"
evidence_basis: "static | real-runtime"
fixed_conditions: []
variable_under_test: "<one variable>"
cases: []
observable_failures: []
repetition: "<count and session reset rule>"
human_validation: "required | optional | not-planned"
stop_conditions: []
privacy_constraints: []
```

`EVALUATION_PLAN` 属于 `audit` 的规划路径，不可注入，也不构成第四个作者模式。

## `BUILD_RECORD`

每次便携或最终 Prompt 构建都必须保留：

```yaml
build_id: "<id>"
parent_build_id: "<id or none>"
build_record_version: "<version>"
role_spec_version: "<version>"
role_spec_ref: "<path, resource id, or attached snapshot id>"
role_spec_hash: "<hash>"
prompt_version: "<version>"
prompt_hash: "<hash>"
build_mode: "portable | final"
runtime_profile_id: "<id or none>"
preservation_map_version: "<version or none>"
trigger_triage_id: "<id or none>"
changed_source: "role_spec | compiler | runtime_profile | none"
primary_hypothesis: "<hypothesis or none>"
skill_version: "<version>"
spec_revision: "<revision>"
validation_status: "author-reviewed | model-tested | human-validated"
created_at: "<ISO date>"
```

构建记录不是第二张角色 Prompt。应把它持久保存在作者工作区；环境无法保留文件或隐藏状态时，将其与单独、明确不可注入的 `ROLE_SPEC` 快照一起提供。

被引用的 `ROLE_SPEC` 也必须可恢复。只有版本号、没有对应语义源的构建记录并不足够。

## `NON_INJECTABLE_MANIFEST`

仅在用户要求时提供，可以记录：

- 来源版本；
- 运行档案标识；
- 高影响假设；
- 保留项与适配项；
- 删除的冲突和不支持能力；
- 验证状态与已知缺口。

必须明确标记为不可注入，并与可部署 Prompt 分开文件或复制块。

## 生命周期

```text
USER_INTENT + CANON
  -> ROLE_SPEC

ROLE_SPEC
  -> PORTABLE_ROLE_PROMPT，运行环境未固定时

ROLE_SPEC + compile-ready RUNTIME_PROFILE
  + PRESERVATION_MAP，重写已接受文本时
  -> FINAL_ROLE_PROMPT

每次便携或最终构建
  -> BUILD_RECORD

真实观察
  -> EVIDENCE_RECORD
  -> TRIAGE_RESULT
  -> 修改 ROLE_SPEC、RUNTIME_PROFILE 或编译规则
  -> 重新构建 Prompt 产物
```

绝不能把上一版生成 Prompt 当作下一轮唯一来源。
