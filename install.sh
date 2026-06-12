#!/bin/sh
# 哆啦A梦 Codex 桌宠一键安装脚本
# 用法: curl -fsSL https://raw.githubusercontent.com/yanqing7914/doraemon-codex-pet/main/install.sh | sh
set -e

REPO="https://raw.githubusercontent.com/yanqing7914/doraemon-codex-pet/main"
DEST="${CODEX_HOME:-$HOME/.codex}/pets/doraemon"

echo "正在安装哆啦A梦 Codex 桌宠..."
mkdir -p "$DEST"
curl -fsSL -o "$DEST/pet.json" "$REPO/pet.json"
curl -fsSL -o "$DEST/spritesheet.webp" "$REPO/spritesheet.webp"

echo "安装完成: $DEST"
echo ""
echo "接下来:"
echo "  1. 重启 Codex 桌面应用"
echo "  2. Settings → Appearance → Pets → 选择 Doraemon"
echo "  3. 在聊天框输入 /pet 唤醒"
