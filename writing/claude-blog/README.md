# AgriciDaniel / claude-blog

来源：[agricidaniel/claude-blog](https://github.com/agricidaniel/claude-blog)（MIT）—— 全生命周期博客引擎，32 个技能覆盖战略、选题、写作、SEO/AI 引用优化、多语言与多媒体素材，主打"Google 排名 + AI 引用"双优化（对应 2026 年核心更新与 E-E-A-T）。

上游仓库还包含 5 个 agents、`brain/` 知识库和 `install.sh` 安装器；本仓库只收录 `skills/` 下的技能本体。

## 技能清单

**主入口 / 路由**

- **blog**：全生命周期引擎，按意图路由到其余 31 个子技能；内含 12 套模板、100 分制评分

**策略与规划**

- **blog-strategy**：内容战略，主题集群 hub-and-spoke 架构与受众映射
- **blog-cluster**：基于 SERP 的关键词研究与主题集群规划
- **blog-calendar**：编辑日历，集群排期与内容更新评审
- **blog-cannibalization**：检测多篇文章间的关键词自相残杀
- **blog-brief**：内容简报（目标关键词、大纲、竞品分析）
- **blog-outline**：SERP 参考的 H2/H3 大纲与内容缺口分析
- **blog-persona**：写作人格，NNGroup 四维语气框架
- **blog-brand**：品牌与声音上下文，产出 `BRAND.md` 供其它技能复用
- **blog-style**：从 5–10 篇已有文章反推作者风格，产出 `VOICE.md`
- **blog-discourse**：近 30 天 Reddit / X / YouTube 舆论调研

**写作与改写**

- **blog-write**：从零写文章：answer-first、要点框、配图、内链、SVG 图表
- **blog-rewrite**：改写存量文章，面向 E-E-A-T 与 AI 引用可见性
- **blog-repurpose**：一稿多投，转社交 / 邮件 / 视频 / 播客
- **blog-translate**：多语言翻译 + SEO 本地化
- **blog-localize**：翻译后的深度文化适配（需先跑 `blog-translate`）
- **blog-multilingual**：一条命令串起写作 → 翻译 → 本地化 → 审计
- **blog-locale-audit**：多语言内容完整性、hreflang、meta 一致性审计

**SEO 与质量**

- **blog-analyze**：5 大类 100 分制评分
- **blog-audit**：全站体检：评分分布、孤儿页、自相残杀、结构问题
- **blog-seo-check**：成稿后的 SEO 通过 / 不通过清单
- **blog-geo**：AI 引用就绪度审计（Google 与 AI 搜索一起看）
- **blog-schema**：JSON-LD 结构化数据生成
- **blog-factcheck**：抓取引用源，逐条核对文中数据是否属实
- **blog-decay**：基于 GSC 导出的内容衰减检测（季度环比下滑、刷新/合并/下线建议）
- **blog-google**：Google 官方 API 集成：PageSpeed、CrUX、Search Console
- **blog-taxonomy**：标签与分类的提取、建议与同步

**素材与多媒体**

- **blog-image**：Gemini 生成与编辑配图（hero、正文插图）
- **blog-chart**：深色模式兼容的 inline SVG 数据图表
- **blog-audio**：Gemini TTS 生成朗读音频
- **blog-notebooklm**：查 NotebookLM 笔记，产出带引用的回答
- **blog-flow**：FLOW 框架（Find-Optimize-Win）证据驱动写作流

## 使用注意

- **技能间有依赖**：主入口是 `blog`，其余按路由调用；`blog-localize` 依赖 `blog-translate` 的参考文件，`blog-multilingual` 依赖 `blog-localize`，同源目录需整体保留，勿单独挑一个复制走。
- **外部依赖**：评分脚本需要 Python 3.11+；`blog-google`、`blog-image`、`blog-audio`、`blog-notebooklm` 需要 Google API / Gemini / NotebookLM 等凭证，没有凭证时相关技能不可用。
- **定位差异**：这套技能面向"英文 SEO + AI 引用"的通用博客生产，与同层的 `human-writing` / `humanizer-zh`（中文活人感写作）、`coding-blog-writing`（中文技术随笔系列）不重叠，可按文章类型分别触发。
