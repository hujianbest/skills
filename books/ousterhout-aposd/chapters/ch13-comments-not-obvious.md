# Chapter 13: 注释应该描述代码中不明显的内容 (Comments Should Describe Things that Aren't Obvious from the Code)

## Core Idea
注释的总原则：**描述从代码（尤其是旁边的声明）看不出来的一切**。"明显"以第一次读你代码的人为准，不以你自己为准。

## Frameworks Introduced
- **注释的四个类别** (按重要性):
  1. **接口注释 (interface)**: 类/数据结构/函数/方法声明前的注释块——描述抽象本身。最重要
  2. **数据结构成员注释**: 字段声明旁。每个类变量都该有
  3. **实现注释 (implementation)**: 方法体内部，描述内部工作方式。多数短方法不需要
  4. **跨模块注释 (cross-module)**: 描述跨模块边界的依赖。最罕见、最难写、需要时极重要
- **先定约定 (pick conventions)**: 跟随 Javadoc/Doxygen/godoc 等工具约定；约定保证一致性且确保"真的写了"。宁可不假思索全注释，也不要逐个纠结该不该注释
- **别重复代码** ——红旗: 注释重复代码。自检: **没见过代码的人只看旁边代码能写出这条注释吗？** 能→无价值。典型病: 逐行注释（一行代码一条注释）；复述名字（注释用词 = 实体名里的词，如 "Downcast PARAMETER to TYPE" 里唯一的新信息是 "to"）。改法: 用**不同的词**、补充名字之外的含义（单位、作用域、边界含义）
- **两个增强方向**:
  - **低层注释添精度 (precision)**: 用于变量/参数/返回值——单位？边界含还是不含？null 意味着什么？资源谁负责释放？不变量（"此表至少一项"）？写"名词"（变量代表什么）而非"动词"（谁怎么改它）
  - **高层注释给直觉 (intuition)**: 省略细节、讲整体意图与结构——"把当前 key hash 附到尚未发出的既有 RPC 上"胜过复述每个条件；"我们如何走到这里 (how we get here)"式注释（何时/为何会执行到这）极有价值
- **接口文档规范**:
  - **严格区分接口注释与实现注释**；接口注释必须描述实现细节 = 类/方法浅的信号（写注释即在设计体检）
  - 类注释: 整体能力、每个实例代表什么、类的限制（如不支持并发）
  - 方法注释: 开头 1-2 句调用者视角的行为描述（高层抽象）；每个参数与返回值的精确定义（含约束、参数间依赖）；副作用；异常；前置条件（尽量少，但残留的必须写）
- **实现注释: 写 what 与 why，不写 how**: 长方法在每个主要代码块前加一句高层描述；循环前描述每次迭代做什么；解释不明显的 why（如引用 bug 库: "Fixes RAM-436"）
- **跨模块设计决策的安放**:
  - 有明显中心 → 放在大家必到之处（RAMCloud Status 枚举尾部列出新增状态要改的 7 处）
  - 无中心 → 集中到 **designNotes 文件**（分主题分节），相关代码处放短引用 "See 'Zombies' in designNotes"

## Worked Example
变量注释前后对比:
```c
// 修改前（模糊）:
// Current offset in resp Buffer
uint32_t offset;
// Contains all line-widths inside the document and number of appearances.
private TreeMap<Integer, Integer> lineWidths;

// 修改后（精确）:
//  Position in this buffer of the first object that hasn't
//  been returned to the client.
uint32_t offset;
//  Holds statistics about line lengths of the form <length, count>
//  where length is the number of characters in a line (including
//  the newline), and count is the number of lines with exactly that
//  many characters. If there are no lines with a particular length,
//  then there is no entry for that length.
private TreeMap<Integer, Integer> numLinesWithLength;
```
键与值是什么、单位、缺项的含义全部落定；名字也从 lineWidths 改为 numLinesWithLength（"length"暗示字符单位、"width"会让人以为是像素）。

IndexLookup 类注释改写: 原版满是 RPC 名称、私有配置参数（实现细节）和"记得 include 头文件"（废话）→ 改为三句话: 客户端用它做索引范围查询、每个实例代表一次查询、getNext 逐个取回对象。服务器崩溃只字不提——因为对用户不可见（自动恢复）。

## Key Takeaways
1. 注释与代码处于**不同详细层级**（更细或更抽象）才有价值；同层=重复
2. 接口注释被实现细节污染 = 设计有问题的免费体检报告
3. 变量注释想名词、精确到单位/边界/不变量
4. 评审者说"不明显"就别争辩——读者觉得不明显，它就不明显

## Connects To
- **Ch 15**: 注释难写 = 抽象不佳的金丝雀信号
- **Ch 16**: 注释的维护（贴近代码、避免重复）
