# vercel-labs / skills

来源：[vercel-labs/skills](https://github.com/vercel-labs/skills) —— Vercel 官方维护的开放 agent skills 工具仓库（`npx skills` CLI），技能生态入口站点为 [skills.sh](https://skills.sh/)。

## 技能清单

- **find-skills**：当你说不清该用什么能力、或想要"有没有现成技能"时触发。它会先查 [skills.sh](https://skills.sh/) 排行榜，再用 `npx skills find <query> [--owner <owner>]` 检索，按安装量/来源信誉/GitHub star 三重标准筛选，最后给出安装命令（`npx skills add <owner/repo@skill> -g -y`）；确实没有匹配技能时，会建议用 `npx skills init` 自建。

## 说明

- 该技能是"元技能"：它不直接干活，而是帮你发现、评估、安装其它技能，适合作为扩充实力的入口。
- 依赖 Node/npx 与网络（`npx skills` 会联网检索 skills.sh 生态）。
