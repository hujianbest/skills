---
name: philosophy-of-software-design
description: "Knowledge base from \"A Philosophy of Software Design (软件设计的哲学)\" by John Ousterhout. Use when applying Ousterhout's frameworks for complexity reduction, deep modules, information hiding, strategic programming, interface design, error handling, comments, naming, or reviewing/redesigning code against his red flags."
---

<!-- argument-hint: [topic, framework name, or chapter number] -->

# 软件设计的哲学 (A Philosophy of Software Design)
**Author**: John Ousterhout (斯坦福, Tcl 发明者) | **Pages**: ~170 (中英对照版 408) | **Chapters**: 21 | **Generated**: 2026-09-03

## How to Use This Skill

- **无参数** — 加载下方核心框架作参考
- **带主题** — 问 `深模块`、`异常处理`、`命名` 等；我会读取对应章节文件再回答
- **带章节号** — 问 `ch10` 即加载该章
- **浏览** — 问 "有哪些章节" 看完整索引

问及核心框架未覆盖的主题时，我会先读相关章节文件再作答。

---

## Core Frameworks & Mental Models

**一句话总纲: 软件设计的核心在于降低复杂性。** 复杂性 = 任何使系统难以理解和修改的结构因素。

### 1. 复杂性解剖 (ch2)
- 公式: **C = Σ cp·tp**（部分复杂度 × 开发时间占比）→ 永不触碰的复杂性 ≈ 不存在
- 三症状: **变更放大**（一处改动要改 N 处）、**认知负荷**（要知道的太多）、**未知的未知**（不知道要改哪/要知道什么——最糟）
- 两根因: **依赖**（不可全消，只可减少+显性化）、**模糊性**（重要信息不明显；靠设计消除优先于靠文档）
- 复杂性是增量累积的 → **零容忍**；用 14 个红旗（见 cheatsheet.md）扫描代码，见红旗即停、寻找替代设计

### 2. 战略编程 (ch3)
- "能工作的代码"不是目标，**长期结构**才是——工作中代码≠可交付设计
- 持续投资 **10-20%** 开发时间于设计（主动: 设计两次/写文档；被动: 见到设计问题就修）；数月内回本
- 警惕**战术龙卷风**（高产但留烂摊子的人）；警惕"忙完这阵再清理"的滑坡

### 3. 深模块 (ch4-5) —— 全书核心词汇
- 模块 = 接口(成本) + 实现；**深 = 接口小而功能大**（Unix 五个 I/O 调用；GC 零接口）
- **信息隐藏**: 每模块封装少数设计决策于实现中；private ≠ 隐藏（getter/setter 照样泄漏）
- 反面红旗: **浅模块**、**信息泄漏**（同一知识多处出现，含后门泄漏）、**时间分解**（按执行顺序而非知识划分模块）、**类炎**（小类崇拜）
- 接口设计铁律: **最常见用法 = 最简调用**；非形式接口（行为注释）比签名更重要

### 4. 适度通用 (ch6-7)
- **功能反映当前需求，接口不反映**——通用接口反而更简单更深（`insert/delete(Position)` 胜过 `backspace/deleteSelection`）
- **不同层必须不同抽象**: 直通方法、同签名浅层链、装饰器滥用都是红旗；传递变量用 context 对象消解
- 专用代码上提、通用机制下沉，**special-general mixture** 是双输

### 5. 复杂性下拉 (ch8)
- 模块开发者多吃苦，换用户少受苦: **简单接口 > 简单实现**
- 抛异常、导出配置参数 = 复杂性上推；判据: "用户能定出比我更好的值吗？"能自动算出的值绝不配置化

### 6. 错误消除 (ch10)
- 异常是最贵的复杂性来源；**抛异常容易，处理异常难**
- 四消法（按序）: ①**定义不存在**（Tcl unset 改"确保不存在"；Unix 文件删除；substring 自动夹取）②**低层屏蔽**（TCP 重发）③**高层聚集**（顶层单点 catch；RAMCloud 损坏对象→崩溃整服务器）④**崩溃**（内存耗尽等罕见不可救错误）
- 推广: 把**特殊情况**也定义不存在（空选区替代"无选区"，消灭 if 特判）

### 7. 设计流程 (ch11-15)
- **Design it twice**: 重大决策强制 2-3 个根本不同方案对比；没人聪明到一次做对
- **注释是抽象的必要组成**（没有注释就无法隐藏复杂性）: 写"代码看不出来的东西"，接口/实现注释严格分离，低层添精度（单位/边界/不变量），高层给直觉
- **先写注释**: 类注释→方法注释+签名→变量注释→方法体；**写不出简单完整的注释 = 抽象有问题**（金丝雀）
- **命名**: 精确+一致；布尔用谓词；取名困难是设计问题的探测器（Sprite 的 block 一名两用 = 6 个月 bug）

### 8. 演化与守护 (ch16-18)
- 改代码的标准: 改完后系统 ≈ "从一开始就带着这次变更设计"的样子；没让设计变好就是在变坏
- 注释维护: 贴近代码、一处决策一处文档、提交前扫 diff
- **一致性**创造认知杠杆: 约定写下来、工具强制执行、"入乡随俗"
- **显而易见**是终极目标: 读者第一猜测即正确；为易读设计而非易写；读者说不明显就不明显

### 9. 趋势检验与性能 (ch19-20)
- 增量单位 = **抽象**而非功能（故反对 TDD 用于开发；修 bug 先写失败测试除外）；实现继承先想组合；单元测试是重构前提；getter/setter 是浅方法
- 干净设计与高性能兼容（简单代码天然快）; 三步走: 性能常识选自然高效设计 → **先测量**（直觉不可靠）→ **关键路径重构**（先写"理想代码"，特判折叠为一个 if，RAMCloud Buffer 提速 2x 且代码 -20%）

---

## Chapter Index

| # | Title | Key Frameworks |
|---|---|---|
| [ch01](chapters/ch01-introduction.md) | 介绍 | 两种对抗复杂性方法, 增量开发 |
| [ch02](chapters/ch02-nature-of-complexity.md) | 复杂性的本质 | 定义/三症状/两根因, C=Σcp·tp, 零容忍 |
| [ch03](chapters/ch03-working-code-isnt-enough.md) | 工作代码是不够的 | 战略 vs 战术编程, 10-20% 投资, 战术龙卷风 |
| [ch04](chapters/ch04-deep-modules.md) | 模块应该是深的 | 深模块, 抽象, 形式/非形式接口, 类炎 |
| [ch05](chapters/ch05-information-hiding.md) | 信息隐藏(和泄漏) | 信息隐藏, 泄漏, 时间分解, 过度暴露, 默认值 |
| [ch06](chapters/ch06-general-purpose-modules.md) | 通用模块更深入 | 适度通用, 自检三问, 虚假抽象 |
| [ch07](chapters/ch07-different-layer-different-abstraction.md) | 不同的层不同的抽象 | 直通方法, 装饰器替代方案, context 对象 |
| [ch08](chapters/ch08-pull-complexity-downwards.md) | 降低复杂性 | 复杂性下拉, 配置参数判据 |
| [ch09](chapters/ch09-together-or-apart.md) | 在一起还是分开 | 细分成本, 合并三判据, 连体方法, History 撤销案例 |
| [ch10](chapters/ch10-define-errors-out-of-existence.md) | 定义不存在的错误 | 四消法, 屏蔽/聚集/崩溃, 消灭特殊情况 |
| [ch11](chapters/ch11-design-it-twice.md) | 设计它两次 | 备选方案对比, 聪明人陷阱 |
| [ch12](chapters/ch12-why-write-comments.md) | 为什么写注释 | 四借口驳斥, 注释与抽象 |
| [ch13](chapters/ch13-comments-not-obvious.md) | 注释写不明显的内容 | 四类注释, 精度/直觉, 接口文档规范, designNotes |
| [ch14](chapters/ch14-choosing-names.md) | 选择的名字 | 精确+一致, Sprite block bug, 布尔谓词 |
| [ch15](chapters/ch15-comments-first.md) | 先写注释 | 注释先行顺序, 注释=设计工具(金丝雀) |
| [ch16](chapters/ch16-modifying-existing-code.md) | 修改现有的代码 | 战略修改, 注释维护三术, diff 检查 |
| [ch17](chapters/ch17-consistency.md) | 一致性 | 认知杠杆, 约定/工具/入乡随俗 |
| [ch18](chapters/ch18-obvious-code.md) | 代码应该显而易见 | 留白, 通用容器反例, 读者裁决 |
| [ch19](chapters/ch19-software-trends.md) | 软件发展趋势 | 接口/实现继承, 敏捷/TDD 批判, 模式过度使用 |
| [ch20](chapters/ch20-designing-for-performance.md) | 设计性能 | 昂贵操作, 测量先行, 关键路径重构, Buffer 案例 |
| [ch21](chapters/ch21-conclusion.md) | 结论 | 全书回顾, 15 原则 + 14 红旗 |

## Topic Index

- **抽象 (abstraction)** → ch04, ch12, ch13
- **注释 (comments)** → ch12, ch13, ch15, ch16
- **复杂性 (complexity)** → ch01, ch02
- **配置参数** → ch08
- **一致性 (consistency)** → ch17, ch14
- **上下文对象 (context)** → ch07
- **深模块 (deep modules)** → ch04, ch05, ch06
- **异常/错误 (errors)** → ch10, ch08
- **信息隐藏 (information hiding)** → ch05, ch09
- **接口设计 (interface)** → ch04, ch06, ch13
- **性能 (performance)** → ch20
- **红旗 (red flags)** → ch21(汇总), cheatsheet.md
- **命名 (naming)** → ch14, ch13
- **战略编程 (strategic programming)** → ch03, ch16
- **战术编程 (tactical programming)** → ch03, ch19
- **重构 (refactoring)** → ch16, ch20
- **拆分/合并 (split/join)** → ch09, ch07
- **TDD/敏捷/单元测试** → ch19
- **直通方法 (pass-through)** → ch07, ch20
- **传递变量 (pass-through variable)** → ch07
- **通用性 (generality)** → ch06, ch09
- **显而易见 (obvious)** → ch18, ch02
- **撤消机制 (undo)** → ch09

## Supporting Files

- [glossary.md](glossary.md) — 全书术语表（中英对照，标注章节）
- [patterns.md](patterns.md) — 9 个可操作技术/模式（含使用时机与步骤）
- [cheatsheet.md](cheatsheet.md) — 15 条设计原则速查表 + 14 个红旗 + 决策树 + 阈值

---

## Scope & Limits

本技能覆盖原书内容（基于中英对照开源译本 gdut_yy 版）。示例多为 Java/C++，思想适用于函数、子系统、服务。结合具体项目工具使用效果更佳；超出本书范围的主题请查阅其他技能。
