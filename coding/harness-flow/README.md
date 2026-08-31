# hujianbest / harness-flow

来源：[hujianbest/harness-flow](https://github.com/hujianbest/harness-flow) —— 个人 HarnessFlow：把 AI 编码 agent 从想法驱动到交付的完整主链，`hf-*` 命名，改编自 [mattpocock/skills](https://github.com/mattpocock/skills)（MIT）。

## 技能清单（相互引用，建议整组使用）

- **hf-workflow**：主链入口，编排后续阶段
- **hf-grill-with-docs**：追问并沉淀领域文档
- **hf-grilling**：需求压力测试
- **hf-domain-modeling**：领域建模（CONTEXT/ADR）
- **hf-to-spec**：对话转 spec
- **hf-to-tickets**：spec 拆票
- **hf-to-architecture**：架构设计
- **hf-to-product-architecture**：产品架构设计
- **hf-codebase-design**：代码库结构设计
- **hf-implement**：按 spec/tickets 实施（调用 hf-tdd、hf-review）
- **hf-tdd**：测试驱动开发
- **hf-review**：跨阶段评审
- **hf-ui-design**：UI 设计
- **hf-ship**：交付/发布

> 与 `coding/mattpocock` 同源但为独立维护版（含进度恢复、auto 模式等扩展），两者按需选用，勿混装同名技能。

## 设计层（本地 overlay）

`hf-ui-design` 叠加了设计层：UI 工作前先选美学方向（调用 `frontend-design`）、按 `taste-skill` 三旋钮校准、绿地创建 `DESIGN.md`；实现与评审强制走"真实渲染 → 截图 → 评审 → 回修"闭环；桌面应用按 HIG/Fluent 平台规范。

细则见 [design-rules.md](design-rules.md)。该增强来自本仓库 `overlays/harness-flow/`，由 `update-skills.sh --sync` 在同步后自动重新应用。
