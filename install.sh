#!/bin/sh
# 哆啦A梦 Codex 桌宠一键安装脚本
# 用法: curl -fsSL https://raw.githubusercontent.com/yanqing7914/doraemon-codex-pet/main/install.sh | sh
set -eu

REPO="${DORAEMON_PET_REPO:-https://raw.githubusercontent.com/yanqing7914/doraemon-codex-pet/main}"
DEST="${CODEX_HOME:-$HOME/.codex}/pets/doraemon"
PARENT=$(dirname "$DEST")
STAGE=""
BACKUP=""
COMMITTED=0

cleanup() {
  status=$?
  if [ "$COMMITTED" -ne 1 ] && [ -n "$BACKUP" ] && [ -d "$BACKUP" ]; then
    [ ! -f "$BACKUP/pet.json" ] || cp "$BACKUP/pet.json" "$DEST/pet.json"
    [ ! -f "$BACKUP/spritesheet.webp" ] || cp "$BACKUP/spritesheet.webp" "$DEST/spritesheet.webp"
  fi
  [ -z "$STAGE" ] || rm -rf "$STAGE"
  [ -z "$BACKUP" ] || rm -rf "$BACKUP"
  exit "$status"
}
trap cleanup EXIT HUP INT TERM

echo "正在下载哆啦A梦 Codex 桌宠..."
mkdir -p "$PARENT" "$DEST"
STAGE=$(mktemp -d "$PARENT/.doraemon-stage.XXXXXX")
BACKUP=$(mktemp -d "$PARENT/.doraemon-backup.XXXXXX")

curl -fsSL -o "$STAGE/pet.json" "$REPO/pet.json"
curl -fsSL -o "$STAGE/spritesheet.webp" "$REPO/spritesheet.webp"
curl -fsSL -o "$STAGE/checksums.sha256" "$REPO/checksums.sha256"

echo "正在校验下载文件..."
(cd "$STAGE" && shasum -a 256 -c checksums.sha256)

# Preserve the current pair until both verified replacements are installed.
[ ! -f "$DEST/pet.json" ] || cp "$DEST/pet.json" "$BACKUP/pet.json"
[ ! -f "$DEST/spritesheet.webp" ] || cp "$DEST/spritesheet.webp" "$BACKUP/spritesheet.webp"
cp "$STAGE/pet.json" "$DEST/.pet.json.new"
cp "$STAGE/spritesheet.webp" "$DEST/.spritesheet.webp.new"
mv "$DEST/.pet.json.new" "$DEST/pet.json"
mv "$DEST/.spritesheet.webp.new" "$DEST/spritesheet.webp"
COMMITTED=1

echo "安装完成: $DEST"
echo ""
echo "接下来:"
echo "  1. 重启 ChatGPT / Codex 桌面应用"
echo "  2. Settings → Appearance → Pets → 选择 Doraemon"
echo "  3. 在聊天框输入 /pet 唤醒"
