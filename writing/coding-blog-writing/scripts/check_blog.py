#!/usr/bin/env python3
"""
check_blog.py - 《一点写代码的心得》系列博文文风、红线与结构扫描工具

用法：
    python3 check_blog.py <markdown_file_path>
"""

import sys
import re
from pathlib import Path

# 违禁翻案腔模式
CONTRAST_PATTERNS = [
    (r"不是[，\s\S]{1,20}?而是", "翻案腔：'不是……而是……'（吴军文风强调平和包容，避免二元对立）"),
    (r"看似[，\s\S]{1,20}?实则", "翻案腔：'看似……实则……'（典型 AI 宣判语气）"),
    (r"并不[，\s\S]{1,20}?而是", "翻案腔：'并不……而是……'"),
    (r"不仅是[，\s\S]{1,20}?更是", "八股排比：'不仅是……更是……'"),
]

# 违禁黑话
BUZZWORDS = [
    "赋能", "闭环", "抓手", "心智", "打法", "范式跃迁", "范式转移",
    "矩阵", "组合拳", "顶层设计", "底层逻辑", "颗粒度", "对齐",
    "背书", "痛点", "壁垒", "下沉"
]

# 违禁八股收尾词
CLICHE_ENDINGS = [
    "总而言之", "综上所述", "总的来说", "写在最后", "结语：", "结论："
]

# 标点符号违规
PUNCTUATION_PATTERNS = [
    (r"——", "严禁使用中文破折号（破坏段落自然呼吸感，显造作）"),
    (r"[：:]\s*\n\s*[-*0-9]", "行尾冒号引出列表（避免八股公文式要点罗列，宜自然叙述）"),
]

# 营销引流与项目叫卖模式（尤其破坏文章人文余韵）
PROMOTION_PATTERNS = [
    (r"写在最后的干货", "文末营销引流用语（极度破坏人文余韵，严禁使用）"),
    (r"(?:欢迎|记得|请)?(?:关注|扫码关注|订阅|点赞|在看|转发|一键三连)", "自媒体套路式关注求赞（系列文章追求纯净，严禁求赞求关注）"),
    (r"(?:项目地址|源码地址|代码仓库|开源地址)[：:\s]*(?:http|https)?:?//", "文末项目外链叫卖（避免将随笔降格为推广软文）"),
    (r"github\.com/[\w\-]+/[\w\-]+", "出现 GitHub 仓库直链（核实是否为篇尾引流，严禁篇尾挂项目推广）"),
]

# 工具说明书化与清单体倾向
MANUAL_PATTERNS = [
    (r"(?:五大|四大|三大|十大|几个)(?:核心模块|必建文件|大步骤|避坑要点)", "说明书式清单标题（警惕滑入微观配置手册，应转为原理阐释）"),
    (r"配置(?:文件)?如下[：:]", "说明书操作指引口吻（避免堆砌配置代码）"),
]

def check_file(file_path: Path):
    if not file_path.exists():
        print(f"❌ 找不到文件：{file_path}")
        sys.exit(1)

    text = file_path.read_text(encoding="utf-8")
    lines = text.splitlines()
    total_lines = len(lines)
    word_count = len(re.findall(r"[\u4e00-\u9fa5a-zA-Z0-9]", text))

    issues = []

    # 1. 检查翻案腔
    for pattern, desc in CONTRAST_PATTERNS:
        matches = re.finditer(pattern, text)
        for m in matches:
            line_no = text[:m.start()].count("\n") + 1
            issues.append((line_no, "翻案腔", f"{desc} -> 命中片段：'{m.group(0)}'"))

    # 2. 检查黑话
    for bw in BUZZWORDS:
        for idx, line in enumerate(lines, 1):
            if bw in line:
                issues.append((idx, "互联网黑话", f"使用严禁黑话 '{bw}'：{line.strip()[:60]}..."))

    # 3. 检查八股收束
    for ce in CLICHE_ENDINGS:
        for idx, line in enumerate(lines, 1):
            if ce in line:
                issues.append((idx, "八股收尾", f"出现公式化八股用语 '{ce}'，建议自然过渡收尾"))

    # 4. 检查标点与格式
    for pattern, desc in PUNCTUATION_PATTERNS:
        matches = re.finditer(pattern, text)
        for m in matches:
            line_no = text[:m.start()].count("\n") + 1
            issues.append((line_no, "标点与排版", f"{desc}"))

    # 5. 检查引流与营销叫卖（重点关注后 30% 篇幅，但全文也做提示）
    for pattern, desc in PROMOTION_PATTERNS:
        matches = re.finditer(pattern, text, re.IGNORECASE)
        for m in matches:
            line_no = text[:m.start()].count("\n") + 1
            is_tail = line_no > total_lines * 0.7
            tail_tag = "【篇尾违规】" if is_tail else "【正文疑似】"
            issues.append((line_no, "营销引流红线", f"{tail_tag} {desc} -> 命中：'{m.group(0)}'"))

    # 6. 检查说明书化倾向
    for pattern, desc in MANUAL_PATTERNS:
        matches = re.finditer(pattern, text)
        for m in matches:
            line_no = text[:m.start()].count("\n") + 1
            issues.append((line_no, "说明书化警示", f"{desc} -> 命中：'{m.group(0)}'"))

    # 7. 输出体检结果
    print("=" * 65)
    print(f"📖 正在体检文章：{file_path.name}")
    print(f"📊 正文字符数（汉字与字母数字）：{word_count}")
    print("=" * 65)

    if issues:
        print(f"⚠️ 发现 {len(issues)} 处需打磨的问题：\n")
        # 按行号排序
        issues.sort(key=lambda x: x[0])
        for line_no, category, detail in issues:
            print(f"  [第 {line_no:4d} 行] 【{category}】 {detail}")
        print("\n💡 建议对照《第一篇 vs 第六篇分水岭解构》与《吴军风格指南》进行润色，杜绝引流与说明书化。")
        return False
    else:
        print("✅ 太棒了！全文无黑话、无翻案腔、无破折号、无八股收束、无营销引流，符合吴军式儒雅随笔规范！")
        return True

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("用法：python3 check_blog.py <markdown_file_path>")
        sys.exit(1)
    
    success = check_file(Path(sys.argv[1]))
    sys.exit(0 if success else 1)
