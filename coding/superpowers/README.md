# obra / superpowers

来源：[obra/superpowers](https://github.com/obra/superpowers)（Jesse Vincent）。skills.sh 上 `brainstorming` 约 33 万次安装、`writing-plans` 约 23 万次安装，是目前社区认可度最高的「先设计、再动手」技能组；也已进入 Anthropic 官方 Claude Code marketplace。

本目录只收录与**设计文档 / 实现计划**直接相关的两个技能。完整套件（TDD、子 agent 执行、code review 等）未收录，需要时可从上游按需补。

## 技能清单

| Skill | 简介 |
|---|---|
| brainstorming | 动手前用对话把想法变成可批准的设计。按 spike / bounded / architectural 三档缩放仪式；architectural 路径会把设计文档写到 `docs/superpowers/specs/`，然后交给 `writing-plans`。硬门：没得到明确批准前不写代码。 |
| writing-plans | 把已批准的设计拆成 2–5 分钟粒度的实现计划（精确路径、完整代码、验证步骤）。禁止 `TBD` 占位。计划写给「零上下文、品味存疑」的工程师/agent 读。 |

## 推荐用法

1. 新功能或架构改动：先跑 `brainstorming`。一次只问一个问题，给出 2–3 个方案和取舍，分段确认设计，再落盘 spec。
2. 设计通过后：跑 `writing-plans` 产出可执行计划。不要把实现细节塞进设计文档。
3. 写 spec 时若装了 [`writing-clearly-and-concisely`](../../writing/writing-clearly-and-concisely)，`brainstorming` 会主动用它压缩文风。
4. 真正按 Google 设计文档结构写给人审的文档时，配合 [`write-design-docs`](../../document/write-design-docs)。

## 未收录

`executing-plans`、`subagent-driven-development`、`test-driven-development`、`using-git-worktrees`、`requesting-code-review` 等属于执行层，不是写设计文档本身。
