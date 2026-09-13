#!/usr/bin/env python3
"""
check_blog.py - 《一点写代码的心得》系列博文文风、红线与结构扫描工具

用法：
    python3 check_blog.py <markdown_file_path>
"""

import sys
import re
from pathlib import Path

# 典型的虚浮 AI 翻案宣判腔（警告）
AI_AFFECTATION_PATTERNS = [
    (r"看似[，\s\S]{1,25}?实则", "AI宣判腔：'看似……实则……'，显得刻意做作，宜用大白话或算账逻辑表达"),
    (r"殊不知", "假书生腔：'殊不知'，破坏程序员自然唠嗑的真实语感"),
    (r"不啻为", "生僻古怪书生腔：'不啻为'，随笔宜平实易懂"),
]

# 严厉禁止的公文与互联网黑话
BUZZWORDS = [
    "赋能", "抓手", "心智", "范式跃迁", "范式转移",
    "组合拳", "顶层设计", "颗粒度", "对齐", "下沉"
]

# 营销套路与引流红线（严厉禁止）
SPAM_PROMOTION_PATTERNS = [
    (r"(?:关注|扫码关注|订阅|点赞|在看|转发|一键三连|加微信|私信领取)", "自媒体套路式关注求赞（系列文章追求纯净，严禁营销号套路）"),
    (r"写在最后的干货[：:]?\s*\[", "套路式干货引流语，容易降格文章意境"),
]

def check_file(file_path: Path):
    if not file_path.exists():
        print(f"❌ 找不到文件：{file_path}")
        return False

    text = file_path.read_text(encoding="utf-8")
    lines = text.splitlines()
    word_count = len(re.findall(r"[\u4e00-\u9fa5a-zA-Z0-9]", text))

    issues = []
    good_signals = []

    # 1. 检查公文黑话
    for bw in BUZZWORDS:
        for idx, line in enumerate(lines, 1):
            if bw in line:
                issues.append((idx, "互联网黑话", f"使用违禁黑话 '{bw}'：{line.strip()[:60]}..."))

    # 2. 检查虚浮宣判腔
    for pattern, desc in AI_AFFECTATION_PATTERNS:
        for m in re.finditer(pattern, text):
            line_no = text[:m.start()].count("\n") + 1
            issues.append((line_no, "造作腔调", f"{desc} -> 命中：'{m.group(0)}'"))

    # 3. 检查自媒体营销引流
    for pattern, desc in SPAM_PROMOTION_PATTERNS:
        for m in re.finditer(pattern, text, re.IGNORECASE):
            line_no = text[:m.start()].count("\n") + 1
            issues.append((line_no, "营销引流", f"{desc} -> 命中：'{m.group(0)}'"))

    # 4. 关键人设与原声正向信号扫描
    has_first_person = bool(re.search(r"[我咱们咱我们]", text))
    if has_first_person:
        good_signals.append("第一人称视角清晰（真诚平视，有我与咱们的同行感）")
    else:
        issues.append((1, "人设缺失", "全文缺乏第一人称（我/咱们），疑似误入第三人称旁观者散文"))

    has_section_numbering = bool(re.search(r"^##\s+[0-9]+[\.、]", text, re.MULTILINE))
    if has_section_numbering:
        good_signals.append("章节层级清晰（具备标准的 ## 1. 结构）")
    else:
        issues.append((1, "结构缺失", "缺乏标准的数字分节标题（如 ## 1.），请保持工程随笔的结构化排版"))

    has_quote_block = bool(re.search(r"^>\s+", text, re.MULTILINE))
    if has_quote_block:
        good_signals.append("善用引用块提炼金句或自嘲插话")

    has_summary = bool(re.search(r"^##\s+(?:[0-9]+[\.、]\s*)?总结", text, re.MULTILINE))
    if has_summary:
        good_signals.append("结尾具备总结章节，完成认知升华")
    else:
        issues.append((len(lines), "结构缺失", "末尾缺少 '## 总结' 或 '## N. 总结' 章节"))

    # 输出体检报表
    print("=" * 65)
    print(f"📖 正在体检文章：{file_path.name}")
    print(f"📊 正文字符数（汉字与字母数字）：{word_count}")
    print("=" * 65)

    if good_signals:
        print("🌟 优秀特质检测：")
        for sig in good_signals:
            print(f"  ✓ {sig}")
        print()

    if issues:
        print(f"⚠️ 发现 {len(issues)} 处需打磨的问题：\n")
        issues.sort(key=lambda x: x[0])
        for line_no, category, detail in issues:
            print(f"  [第 {line_no:4d} 行] 【{category}】 {detail}")
        print("\n💡 建议对照《胡健 Voice 规范》与《系列典范拆解》进行微调。")
        return False
    else:
        print("✅ 太棒了！全文无黑话、无人设偏离、无营销引流，结构规整，契合《一点写代码的心得》系列规范！")
        return True

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("用法：python3 check_blog.py <markdown_file_path>")
        sys.exit(1)
    
    success = check_file(Path(sys.argv[1]))
    sys.exit(0 if success else 1)
