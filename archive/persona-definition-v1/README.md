# Persona Definition v1 Archive

Status: `historical`, `superseded-as-entry`, `archived-benchmark-artifact`.

## 简体中文

### 定位

本目录保存 2026-08-25 版本角色卡作者 Skill 的独立双语归档。它不是另一个前身仓库，而是把公开博客文章内嵌的中文正文整理成可单独读取、可校验的历史文件，并配套保存项目维护的英文译本。

这套早期端到端方法同时覆盖角色定义、工具、平台格式、冲突审查、测试和迭代修复。它不是当前 Role Prompt Authoring Skill 的 `define` 模式，也不得与当前 Skill 同时加载。

当前入口：

- 中文：[现实私聊角色 Prompt 作者 Skill](../../skills/role-prompt-authoring/role-prompt-authoring-skill.zh-CN.md)
- 迁移说明：[历史来源与方法迁移](../../docs/zh-CN/migration.md)

### 来源与可追溯性

- 公开文章源码：[《给 AstrBot 写人设提示词这件事,我踩过的一些坑》](https://github.com/Yuimi-chaya/Yuimi-chaya.github.io/blob/main/src/content/blog/astrbot-roleplay-persona-notes.md)
- 固定来源快照：[博客仓库提交 `9ddf51215ec7bbcf86d3f43eaf682543a4ced6ce`](https://github.com/Yuimi-chaya/Yuimi-chaya.github.io/blob/9ddf51215ec7bbcf86d3f43eaf682543a4ced6ce/src/content/blog/astrbot-roleplay-persona-notes.md)
- 来源路径：`src/content/blog/astrbot-roleplay-persona-notes.md`
- 固定来源提交：`9ddf51215ec7bbcf86d3f43eaf682543a4ced6ce`

截至 2026-09-02，文章内嵌代码块中的中文 Skill 正文在解码 HTML 实体并统一换行与末尾空白后，与本目录中文文件正文一致。文章里的 Skill 元数据包装和 HTML 容器不属于独立归档文件。英文文件是本项目维护的配套译本，不声称该文件曾包含在公开文章中。

### 许可

仓库所有者 `Yuimi-chaya` 确认其拥有中文 Skill 正文并授权本归档以根目录 MIT License 发布；本项目维护的英文译本也纳入该许可。该授权只覆盖本仓库实际保存的两个文件，不覆盖外链博客仓库的完整文章或其他内容。详见 [`LICENSE-SCOPE.md`](../../LICENSE-SCOPE.md)。

### 文件

| 文件 | 性质 | SHA-256 |
| --- | --- | --- |
| [`immersive-role-prompt-engineering-skill.zh-CN.md`](immersive-role-prompt-engineering-skill.zh-CN.md) | 文章内嵌中文 Skill 正文的独立冻结文件 | `7FE9D99281972A1C427E8119DCA93BDFB1F070662150B7E82EBFC3F2BE35A350` |
| [`immersive-role-prompt-engineering-skill.en.md`](immersive-role-prompt-engineering-skill.en.md) | 项目维护的英文配套译本 | `167E18B6DE848BDD7A8F9485A8C8330D4B57C9719847A56917AD62263981CE41` |

### 与当前方法的关系

当前架构继承其中关于最小充分、人格因果、可观察倾向、冲突审查和控制变量迭代的经验，但重新分配了职责：稳定角色语义进入 `ROLE_SPEC`，运行能力与格式由宿主和 `RUNTIME_PROFILE` 持有，共享测试与归因由统一评测协议持有。归档正文保持不变，不会被静默改写成当前规范。

## English

### Position

This directory preserves a standalone bilingual archive of the 2026-08-25 persona-authoring Skill. It is not a separate predecessor repository. It turns the Chinese Skill body embedded in a public blog article into an independently readable and verifiable historical file, paired with an English translation maintained by this project.

The earlier end-to-end method covers persona definition, tools, platform formatting, conflict review, testing, and iterative repair. It is not the current Role Prompt Authoring Skill's `define` mode and must not be loaded alongside the current Skill.

Current entry points:

- English: [Direct-Message Role Prompt Authoring Skill](../../skills/role-prompt-authoring/role-prompt-authoring-skill.en.md)
- Migration: [Historical Sources And Migration](../../docs/en/migration.md)

### Provenance

- Live public article source: [《给 AstrBot 写人设提示词这件事,我踩过的一些坑》 (“Lessons From Writing Persona Prompts For AstrBot”)](https://github.com/Yuimi-chaya/Yuimi-chaya.github.io/blob/main/src/content/blog/astrbot-roleplay-persona-notes.md)
- Pinned source snapshot: [blog repository commit `9ddf51215ec7bbcf86d3f43eaf682543a4ced6ce`](https://github.com/Yuimi-chaya/Yuimi-chaya.github.io/blob/9ddf51215ec7bbcf86d3f43eaf682543a4ced6ce/src/content/blog/astrbot-roleplay-persona-notes.md)
- Source path: `src/content/blog/astrbot-roleplay-persona-notes.md`
- Pinned source commit: `9ddf51215ec7bbcf86d3f43eaf682543a4ced6ce`

As verified on 2026-09-02, the Chinese Skill body embedded in the article matches the Chinese archive body after HTML entity decoding and normalization of line endings and trailing whitespace. The article's Skill metadata wrapper and HTML container are not part of the standalone archive file. The English file is a project-maintained companion translation and is not claimed to be an English original from the article.

### License

Repository owner `Yuimi-chaya` confirms ownership of the Chinese Skill body and authorizes this archived copy under the root MIT License. The project-maintained English translation is covered as well. This grant applies only to the two files stored in this repository, not to the complete linked article or other content in the external blog repository. See [`LICENSE-SCOPE.md`](../../LICENSE-SCOPE.md).

### Files

| File | Status | SHA-256 |
| --- | --- | --- |
| [`immersive-role-prompt-engineering-skill.zh-CN.md`](immersive-role-prompt-engineering-skill.zh-CN.md) | Standalone freeze of the article-embedded Chinese Skill body | `7FE9D99281972A1C427E8119DCA93BDFB1F070662150B7E82EBFC3F2BE35A350` |
| [`immersive-role-prompt-engineering-skill.en.md`](immersive-role-prompt-engineering-skill.en.md) | Project-maintained English companion translation | `167E18B6DE848BDD7A8F9485A8C8330D4B57C9719847A56917AD62263981CE41` |

### Relationship To The Current Method

The current architecture retains lessons about minimum sufficiency, personality causality, observable tendencies, conflict review, and controlled iteration while assigning their responsibilities more precisely. Stable character semantics belong to `ROLE_SPEC`; runtime capability and formatting belong to the host and `RUNTIME_PROFILE`; shared testing and triage belong to the unified evaluation protocol. The archived bodies remain unchanged and are not silently rewritten to match current behavior.
