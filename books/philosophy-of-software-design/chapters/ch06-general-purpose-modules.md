# Chapter 6: 通用模块更深入 (General-Purpose Modules are Deeper)

## Core Idea
新模块的最佳实现方式是"**适度通用 (somewhat general-purpose)**"：功能反映当前需求，**接口不反映**——接口应足够通用以支持多种用途，但别通用到难以服务当前需求。最反直觉的收益：通用接口比专用接口**更简单、更深**。

## Frameworks Introduced
- **somewhat general-purpose 原则**:
  - "somewhat" 是关键限定词——过于通用会难用于当下
  - 通用接口即使在原始用途下也更优（简单性收益即刻兑现，不依赖未来复用）
- **通用性改善信息隐藏**: 通用机制不含专用代码 → 与使用方（如 UI 类）干净分离，专用细节封装在使用方模块里；专用接口则泄漏使用方的抽象

## Key Concepts
- **虚假抽象的又一形态**: `backspace()` 方法假装隐藏"删了哪些字符"，但 UI 模块真的需要知道这个 → 隐藏重要细节只会制造模糊。软件设计的核心问题之一：**确定谁在何时需要知道什么**；细节重要时就让它显式而明显
- **专用方法的信号**: 一个方法只对应一种用途/只在一处被调用

## Worked Example
GUI 文本编辑器的 text 类（贯穿 ch6-9 的案例）：
- 专用 API（差）: `backspace(Cursor)`、`delete(Cursor)`、`deleteSelection(Selection)` ——UI 每个键位一个方法，text 类充满浅方法；UI 抽象（Selection/Cursor）泄漏进 text 类；新 UI 功能就得改 text 类
- 通用 API（好）:
  ```java
  void insert(Position position, String newText);
  void delete(Position start, Position end);
  Position changePosition(Position position, int numChars);
  ```
  用 Position（通用）替代 Cursor（UI 概念）。退格键实现：`text.delete(text.changePosition(cursor, -1), cursor)` ——比专用方法长一点，但**删除了哪些字符一目了然**（不必再去读 backspace 的实现）；总代码量更少；换一个应用（批量替换工具）只需补一个 `findNext(start, s)`

## 自检三问 (Questions to ask yourself)
1. **满足当前所有需求的最简单接口是什么？** 减方法数而不减整体能力 → 在变得通用（前提：单个方法的 API 仍简单；靠大量参数换方法数是假简化）
2. **这个方法会在多少种情况下被使用？** 只服务一种用途是红旗——试试用一个通用方法替换多个专用方法
3. **这个 API 用于当前需求顺手吗？** 通用过头的探测器——要写大量额外代码才能用于当下（如只支持单字符操作的 text 类），说明功能层级不对

## Key Takeaways
1. 功能专用、接口通用——两者分开决策
2. 通用化最常见的形式：用一个带参数的通用方法替代一族专用方法
3. 通用性不是为了未来复用，而是为了当下更简单

## Connects To
- **Ch 4-5**: 通用性是达深模块+信息隐藏的路径
- **Ch 8**: 面向字符的接口同时也是"把复杂性下拉"的例子
- **Ch 19**: 敏捷"先做最小专用实现、以后再重构通用"的主张与本章相抵——作者认为一旦需要抽象就一次设计好
