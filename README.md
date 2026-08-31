# Skills 合集

个人日常使用的 AI Agent Skills 集合，从 GitHub 加星仓库中精选，按用途分为四类。每个 skill 都是标准 `SKILL.md` 结构（含配套 references / scripts / assets），可被 Codex、Claude Code 等支持 Agent Skills 规范的 agent 直接使用。

## 目录结构

| 目录 | 用途 | 数量 |
|---|---|---|
| [coding/addyosmani/](coding/addyosmani) | 工程技能（Addy Osmani） | 13 |
| [coding/anthropics/](coding/anthropics) | 官方技能（Anthropic） | 5 |
| [coding/karpathy/](coding/karpathy) | Karpathy 编码规范 | 1 |
| [coding/khazix/](coding/khazix) | 卡兹克技能 | 1 |
| [coding/taste-skill/](coding/taste-skill) | 设计品味·工程向 | 2 |
| [mattpocock/](mattpocock) | mattpocock 工程技能家族（相互依赖，整组使用） | 12 |
| [document/](document) | 文档、办公、知识 | 6 |
| [image/](image) | 图片、设计、视觉 | 15 |
| [writing/](writing) | 写作、内容创作 | 2 |

## 使用方式

将需要的 skill 目录复制到你的 agent 的 skills 目录（如 Codex 的 `.codex/skills`、Claude Code 的 `.claude/skills`），或在提示中直接引用对应路径。多数 skill 支持按需触发，无需手动开启。

## coding/ — 编程与工程

按来源分组整理，避免混用；每组技能同源，详见对应子目录 README。

### coding/addyosmani/（13 个）— [addyosmani/agent-skills](https://github.com/addyosmani/agent-skills)

| Skill | 简介 |
|---|---|
| browser-testing-with-devtools | 用 Chrome DevTools MCP 在真实浏览器中测试与调试 |
| code-review-and-quality | 多维度代码审查 |
| code-simplification | 不改变行为地简化代码 |
| documentation-and-adrs | 架构决策记录与文档沉淀 |
| doubt-driven-development | 对每个非平凡决策做对抗式复查 |
| frontend-ui-engineering | 生产级、可访问、响应式 UI 构建 |
| incremental-implementation | 增量式交付变更 |
| interview-me | 通过提问挖掘真实需求 |
| performance-optimization | 前后端、查询、数据库性能优化 |
| planning-and-task-breakdown | 把需求拆解为有序任务 |
| source-driven-development | 以官方文档为依据进行开发 |
| spec-driven-development | 先写 spec 再编码 |
| test-driven-development | 测试驱动开发 |

### coding/anthropics/（5 个）— [anthropics/skills](https://github.com/anthropics/skills)

| Skill | 简介 |
|---|---|
| discernment-nudge | 交付重要答复前追加针对性追问 |
| frontend-design | 有辨识度的前端视觉设计指导 |
| mcp-builder | 高质量 MCP server 开发指南 |
| skill-creator | 创建、优化并评估 skill |
| webapp-testing | Playwright 本地 Web 应用测试工具包 |

### coding/karpathy/（1 个）— [multica-ai/andrej-karpathy-skills](https://github.com/multica-ai/andrej-karpathy-skills)

| Skill | 简介 |
|---|---|
| karpathy-guidelines | Karpathy 编码行为规范，减少常见 LLM 编码错误 |

### coding/khazix/（1 个）— [KKKKhazix/khazix-skills](https://github.com/KKKKhazix/khazix-skills)

| Skill | 简介 |
|---|---|
| leader | 把一句话想法拆成 agent 可执行的目标任务书 |

### coding/taste-skill/（2 个）— [Leonxlnx/taste-skill](https://github.com/Leonxlnx/taste-skill)

| Skill | 简介 |
|---|---|
| image-to-code-skill | 先生成设计图、再据此实现网站（Codex 向） |
| output-skill | 强制完整输出、禁止占位符（防截断） |

**mattpocock 家族**（12 个）：[grill-me](mattpocock/grill-me)、[grill-with-docs](mattpocock/grill-with-docs)、[grilling](mattpocock/grilling)、[domain-modeling](mattpocock/domain-modeling)、[to-spec](mattpocock/to-spec)、[to-tickets](mattpocock/to-tickets)、[implement](mattpocock/implement)、[tdd](mattpocock/tdd)、[code-review](mattpocock/code-review)、[setup-matt-pocock-skills](mattpocock/setup-matt-pocock-skills)、[teach](mattpocock/teach)、[writing-for-agents](mattpocock/writing-for-agents)。它们相互依赖（如 `grill-with-docs` 调用 `grilling` + `domain-modeling`，`implement` 调用 `tdd` + `code-review`），需整组安装，详见 [mattpocock/README.md](mattpocock/README.md)。来源：[mattpocock/skills](https://github.com/mattpocock/skills)。

## document/ — 文档与办公

| Skill | 简介 | 来源 |
|---|---|---|
| doc-coauthoring | 结构化文档协作工作流 | [anthropics/skills](https://github.com/anthropics/skills) |
| docx | Word 文档创建、编辑、批注与修订 | 同上 |
| pdf | PDF 全套处理（提取、合并、表单、OCR 等） | 同上 |
| pptx | PPT 创建、编辑与格式转换 | 同上 |
| xlsx | 电子表格读写、清洗与格式化 | 同上 |
| hv-analysis | 横纵分析法深度研究，产出 PDF 报告 | [KKKKhazix/khazix-skills](https://github.com/KKKKhazix/khazix-skills) |

## image/ — 图片与设计

| Skill | 简介 | 来源 |
|---|---|---|
| algorithmic-art | 用 p5.js 生成算法艺术 | [anthropics/skills](https://github.com/anthropics/skills) |
| canvas-design | 海报与视觉艺术创作（PNG/PDF） | 同上 |
| baoyu-article-illustrator | 文章配图（Type × Style × Palette） | [JimLiu/baoyu-skills](https://github.com/JimLiu/baoyu-skills) |
| baoyu-comic | 多风格知识漫画生成 | 同上 |
| huashu-design | HTML 高保真原型、幻灯片、动画、可视化设计 | [alchaincyf/huashu-design](https://github.com/alchaincyf/huashu-design) |
| ian-xiaohei-illustrations | 中文「小黑」怪诞正文配图 | [helloianneo/ian-xiaohei-illustrations](https://github.com/helloianneo/ian-xiaohei-illustrations) |
| brandkit | 高端品牌视觉图册生成 | [Leonxlnx/taste-skill](https://github.com/Leonxlnx/taste-skill) |
| brutalist-skill | 粗野主义工业风格界面 | 同上 |
| imagegen-frontend-mobile | 高端移动端界面概念图生成 | 同上 |
| imagegen-frontend-web | 高转化网页设计参考图生成 | 同上 |
| minimalist-skill | 极简编辑风界面 | 同上 |
| redesign-skill | 现有网站/应用升级为高级质感 | 同上 |
| soft-skill | 高端机构级设计规范（字体/间距/动效） | 同上 |
| stitch-skill | 生成 DESIGN.md 语义设计系统 | 同上 |
| taste-skill | 反 AI 味的前端设计（落地页/作品集/改版） | 同上 |

> 注：taste-skill 系列中部分目录名与内部触发名不同（如 `output-skill` 内部名为 `full-output-enforcement`、`taste-skill` 为 `design-taste-frontend`），复制使用时以目录名为准即可。

## writing/ — 写作与内容创作

| Skill | 简介 | 来源 |
|---|---|---|
| human-writing | 活人感中文写作与改稿 | [KKKKhazix/human-writing](https://github.com/KKKKhazix/human-writing) |
| humanizer-zh | 去除文本中的 AI 写作痕迹 | [op7418/Humanizer-zh](https://github.com/op7418/Humanizer-zh) |

## 说明

- Skills 来自多个开源项目，各目录保留了原项目的 LICENSE 文件；个人使用无碍，对外再分发时请留意各自许可条款。
- 完整仓库筛选清单见 [github-skills-list.md](github-skills-list.md)。
