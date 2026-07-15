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
BACKUP_READY=0
HAD_PET=0
HAD_SPRITESHEET=0

cleanup() {
  status=$?
  if [ "$COMMITTED" -ne 1 ] && [ "$BACKUP_READY" -eq 1 ] && [ -n "$BACKUP" ] && [ -d "$BACKUP" ]; then
    if [ "$HAD_PET" -eq 1 ]; then cp "$BACKUP/pet.json" "$DEST/pet.json"; else rm -f "$DEST/pet.json"; fi
    if [ "$HAD_SPRITESHEET" -eq 1 ]; then cp "$BACKUP/spritesheet.webp" "$DEST/spritesheet.webp"; else rm -f "$DEST/spritesheet.webp"; fi
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
if command -v shasum >/dev/null 2>&1; then
  (cd "$STAGE" && shasum -a 256 -c checksums.sha256)
elif command -v sha256sum >/dev/null 2>&1; then
  (cd "$STAGE" && sha256sum -c checksums.sha256)
else
  echo "错误:需要 shasum 或 sha256sum 来校验下载文件" >&2
  exit 1
fi

# Preserve the current pair until both verified replacements are installed.
if [ -f "$DEST/pet.json" ]; then HAD_PET=1; cp "$DEST/pet.json" "$BACKUP/pet.json"; fi
if [ -f "$DEST/spritesheet.webp" ]; then HAD_SPRITESHEET=1; cp "$DEST/spritesheet.webp" "$BACKUP/spritesheet.webp"; fi
BACKUP_READY=1
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
