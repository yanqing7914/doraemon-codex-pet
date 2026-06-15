# 哆啦A梦 Codex 桌宠(科目三版)

一只为 [OpenAI Codex](https://openai.com/codex/) 桌面应用定制的哆啦A梦桌宠。

它会悬浮在屏幕最顶层,实时显示 Codex 的工作状态:**派活后专注思考,干完活起身跳科目三庆祝,翻车了瘫倒在地**。

![专注干活](previews/running.gif) ![科目三](previews/waving.gif) ![失败](previews/failed.gif)

## 特色

在标准哆啦A梦宠物包的基础上定制了两个动画:

- **专注干活**:Codex 在后台执行任务时,哆啦A梦会摆出思考、查看、认真处理的动作,不再抱着电脑打字。站立帧与工作帧保持同一头身比,切换时不会突然变大
- **官方配色校准**:全表主体蓝校准到官方哆啦A梦标准蓝 `#00A0E9`,各状态配色统一
- **科目三庆祝舞**:任务完成时跳一段抖音科目三——扭胯、踢腿、甩臂画腕(原版是普通挥手)。按官方契约 waving 行为 4 帧,从 8 帧原始动作中抽取关键帧制作

## 安装

### 方式一:一键安装(Mac / Linux)

```bash
curl -fsSL https://raw.githubusercontent.com/yanqing7914/doraemon-codex-pet/main/install.sh | sh
```

### 方式二:命令行手动下载

```bash
mkdir -p ~/.codex/pets/doraemon
curl -fsSL -o ~/.codex/pets/doraemon/pet.json https://raw.githubusercontent.com/yanqing7914/doraemon-codex-pet/main/pet.json
curl -fsSL -o ~/.codex/pets/doraemon/spritesheet.webp https://raw.githubusercontent.com/yanqing7914/doraemon-codex-pet/main/spritesheet.webp
```

### 方式三:手动安装(含 Windows)

1. 下载本仓库的 `pet.json` 和 `spritesheet.webp` 两个文件
2. 放到以下目录(没有就新建):
   - Mac / Linux:`~/.codex/pets/doraemon/`
   - Windows:`C:\Users\<你的用户名>\.codex\pets\doraemon\`

### 启用

1. 重启 Codex 桌面应用
2. 打开 `Settings → Appearance → Pets`,在 Custom pets 里选择 **Doraemon**
3. 在 Codex 聊天框输入 `/pet` 唤醒

> 注意:桌宠功能只在 Codex 桌面应用中可用,CLI 不支持。

## 全部动画状态

| 状态 | 预览 | 触发时机 |
|---|---|---|
| 发呆 idle | ![idle](previews/idle.gif) | 没有任务时,呼吸眨眼 |
| 专注干活 running | ![running](previews/running.gif) | Codex 在后台干活时 |
| 检查 review | ![review](previews/review.gif) | Codex 审查代码时 |
| 等待 waiting | ![waiting](previews/waiting.gif) | 等你批准操作(气泡显示红色时钟) |
| 跳跃 jumping | ![jumping](previews/jumping.gif) | 需要你做决定时 |
| 科目三 waving | ![waving](previews/waving.gif) | 任务完成(气泡显示绿色对勾) |
| 失败 failed | ![failed](previews/failed.gif) | 任务失败,瘫倒 |
| 向右跑 | ![running-right](previews/running-right.gif) | 被向右拖动时 |
| 向左跑 | ![running-left](previews/running-left.gif) | 被向左拖动时 |

完整图集总览见 [previews/contact-sheet.png](previews/contact-sheet.png)。

## 文件结构

```text
doraemon-codex-pet/
├── pet.json           # 宠物元数据:名称、图集网格、各状态行号与帧数
├── spritesheet.webp   # 动画图集:1536×1872,8列×9行,单帧192×208,透明背景
└── previews/          # 各状态 GIF 预览(仅供展示,安装时不需要)
```

遵循 [Codex 宠物包标准格式](https://github.com/openai/skills/blob/main/skills/.curated/hatch-pet/SKILL.md):每行一个动画状态,行内从第 0 列开始取连续非空帧播放。

## 制作说明

- 基础形象来自 [Petdex](https://petdex.dev) 社区的 doraemon 宠物包(作者 korkyzer)
- 专注干活和科目三两行动画为 AI 生成后,经色键抠图、按头宽与基线对齐缩放、碎片清理后合成
- 详细 DIY 方法可参考 [openai/skills 的 hatch-pet 技能](https://github.com/openai/skills/blob/main/skills/.curated/hatch-pet/SKILL.md)

## 版权声明

哆啦A梦(Doraemon)角色版权归藤子·F·不二雄/藤子プロ及相关权利方所有。本项目为粉丝创作(fan art),仅供个人学习娱乐使用,**请勿用于任何商业用途**。
