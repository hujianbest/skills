# Chapter 4: 模块应该是深的 (Modules Should Be Deep)

## Core Idea
最好的模块是**深模块**：接口很小很简单，背后隐藏大量功能。深度是本书最核心的设计词汇——模块的接口是它强加给系统其余部分的成本（复杂性），功能是它的收益。

## Frameworks Introduced
- **模块 = 接口 + 实现**: 模块是任何具有接口和实现的代码单元（类、方法、函数、子系统、服务）。接口 = 使用者必须知道的一切；实现 = 履行接口承诺的代码
- **接口的形式部分与非形式部分**: 形式部分（签名、参数类型）可被语言检查；非形式部分（高层行为、使用约束、调用顺序要求）只能用注释描述，且通常**更大更复杂**。接口说明得清楚，"未知的未知"问题就被消除
- **深 vs 浅 (deep vs shallow)**（图 4.1 矩形模型: 面积=功能, 顶边=接口）
  - **深模块**: 功能强大 + 接口简单；只暴露内部复杂性的极小部分。例：Unix I/O 五个系统调用 (open/read/write/lseek/close) 背后是数十万行实现；垃圾收集器——零接口反而**缩小**了系统整体接口
  - **浅模块 (shallow module)**: 接口复杂度 ≈ 实现复杂度（如链表类）；几乎不隐藏复杂性。红旗：浅模块
- **类炎 (classitis)**: "类是好的所以越多越好"的综合征；追求小类导致海量浅类+海量接口，系统级复杂性爆炸、样板冗长。"任何超过 N 行的方法都该拆"（N 可低至 10）是同一病症

## Key Concepts
- **抽象 (abstraction)**: 实体的简化视图，省略**不重要**的细节。两种出错方式：①包含了不重要的细节（徒增认知负荷）②漏掉了重要的细节（→ **虚假抽象 false abstraction**：看起来简单，实际不简单）。关键在分辨什么是重要的，并最小化重要的信息量
- **接口设计让常见情况尽可能简单**: Unix 顺序 I/O 为默认、lseek 处理随机访问是典型；接口功能多但常用功能少 → 有效复杂度 = 常用功能的复杂度
- **做正确的事 (do the right thing)**: 类应无需被明确要求就做对的事；最好的功能是你根本不知道它存在的功能（如默认缓冲）

## Worked Example
Java 类库的类炎反例：打开文件读序列化对象需创建三个对象——
```java
FileInputStream fileStream = new FileInputStream(fileName);
BufferedInputStream bufferedStream = new BufferedInputStream(fileStream);
ObjectInputStream objectStream = new ObjectInputStream(bufferedStream);
```
fileStream/bufferedStream 打开后即弃；忘记包 BufferedInputStream 就没有缓冲且 I/O 缓慢。缓冲几乎人人需要，应默认内置（Java 设计者给了选择，但选择恰恰是负担）。对比 Unix：让常见情况简单。

## Anti-patterns
- **以类/方法数量或行数论质量**: 小类趋于浅；"更小"不一定"更简单"
- **为每个小功能单开一个类**（见第 7 章装饰器）

## Key Takeaways
1. 评价模块先看深度：接口复杂度 vs 提供的功能
2. 非形式接口（注释）与形式接口同样真实——大多数接口的非形式部分更大
3. 把"最常用用法最简单"作为接口设计的硬约束；罕见需求藏在干净分离的机制后面
4. 接口不错，但更多/更大的接口不一定更好

## Connects To
- **Ch 5-6**: 达成深模块的两大技术：信息隐藏、适度通用
- **Ch 7**: 浅模块的典型形态（直通方法、装饰器）
