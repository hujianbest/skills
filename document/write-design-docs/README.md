# write-design-docs

来源：[pproenca/dot-skills](https://github.com/pproenca/dot-skills)（上游标为 experimental）。依据 Malte Ubl 的 [Design Docs at Google](https://www.industrialempathy.com/posts/design-docs-at-google/)：设计文档是**解题和达成共识的工具**，不是实现手册。

仓库星标不高，收录的是方法论本身——Google 设计文档是业界写「人能读懂」的设计文档的标准参考。它直接针对 AI 文档的常见病：章节堆满、实现细节淹没决策、审稿人读不下去。

## 核心约束

- 先判断要不要写：方案显而易见、没有真实取舍时，用 issue / 短笔记，不要硬写全文。
- 围绕 **Context / Goals / Non-goals / Design / Alternatives** 写决策和权衡。
- 为忙碌的审稿人优化：链接详细需求、原型、schema，不要整段拷贝。
- 小而有歧义的改动写 **mini design doc**（1–3 页），而不是 20 节模板。
- 细则、审稿清单见 [references/design-doc-guidance.md](references/design-doc-guidance.md)。

## 和本仓库其他技能的关系

- 动手前澄清想法：[`brainstorming`](../../coding/superpowers)
- 设计通过后拆任务：[`writing-plans`](../../coding/superpowers)
- 文风去晦涩：[`writing-clearly-and-concisely`](../../writing/writing-clearly-and-concisely)
- 访谈 + ADR：已有 [`grill-with-docs`](../../coding/mattpocock)
