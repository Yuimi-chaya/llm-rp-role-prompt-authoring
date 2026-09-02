# Private Chat Compilation v0 Archive

Status: `historical`, `experimental-companion`, `superseded-as-entry`.

## 简体中文

本目录保存本项目于 2026-09-01 编写的双语 companion 编译器原型。它尝试了统一重写、运行条件化来源语义、私聊动作选择和唯一最终 Prompt，但仍与角色定义及测试职责重叠。

这里的 `private-chat` 表示目标交互场景。两个 Skill 文件都是抽象作者方法，不包含真实聊天、用户资料、截图、模型日志或部署配置。

该原型不是当前公共入口；其中有效的编译行为已经并入统一 Role Prompt Authoring Skill 的 `compile` 模式。不要把它追加到角色卡，也不要与当前 Skill 同时加载。

### 来源与许可

中英文正文均由本项目维护，未从 HDSI 或其他第三方项目复制代码、固定 Prompt、JSON 合同或实现文件。仓库所有者 `Yuimi-chaya` 授权两份正文及本 README 按根目录 MIT License 发布。许可范围见 [`LICENSE-SCOPE.md`](../../LICENSE-SCOPE.md)。

### 文件

| 文件 | SHA-256 |
| --- | --- |
| [`private-chat-role-prompt-compiler-skill.zh-CN.md`](private-chat-role-prompt-compiler-skill.zh-CN.md) | `CE4EADD0AA89C94504834B2C98930AFD4084D4AE896149AA5862E9A9203C1992` |
| [`private-chat-role-prompt-compiler-skill.en.md`](private-chat-role-prompt-compiler-skill.en.md) | `1CFE35A51C6C8E1F40611D28D4F27F26E10EAADE09118C914C57C387A1054F95` |

## English

This directory preserves the bilingual companion compiler prototype authored within this project on 2026-09-01. It explored unified rewriting, runtime-aware source semantics, private-chat action selection, and one final Prompt, while still overlapping with persona-definition and testing responsibilities.

The term `private-chat` describes the target interaction setting. Both Skill files are abstract authoring methods and contain no real conversation, user data, screenshot, model log, or deployment configuration.

This prototype is not a current public entry point. Its useful compilation behavior has been folded into the `compile` mode of the unified Role Prompt Authoring Skill. Do not append it to a persona card or load it together with the current Skill.

### Provenance And License

Both language versions are maintained by this project. They do not copy HDSI or other third-party source code, fixed Prompts, JSON contracts, or implementation files. Repository owner `Yuimi-chaya` authorizes both bodies and this README under the root MIT License. See [`LICENSE-SCOPE.md`](../../LICENSE-SCOPE.md).

### Files

| File | SHA-256 |
| --- | --- |
| [`private-chat-role-prompt-compiler-skill.zh-CN.md`](private-chat-role-prompt-compiler-skill.zh-CN.md) | `CE4EADD0AA89C94504834B2C98930AFD4084D4AE896149AA5862E9A9203C1992` |
| [`private-chat-role-prompt-compiler-skill.en.md`](private-chat-role-prompt-compiler-skill.en.md) | `1CFE35A51C6C8E1F40611D28D4F27F26E10EAADE09118C914C57C387A1054F95` |
