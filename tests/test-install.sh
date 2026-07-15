#!/bin/sh
set -eu

ROOT=$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)
TMP=$(mktemp -d "${TMPDIR:-/tmp}/doraemon-install-test.XXXXXX")
trap 'rm -rf "$TMP"' EXIT HUP INT TERM

mkdir -p "$TMP/home/pets/doraemon" "$TMP/broken"
cp "$ROOT/pet.json" "$ROOT/spritesheet.webp" "$TMP/home/pets/doraemon/"
cp "$ROOT/pet.json" "$TMP/broken/"

before=$(shasum -a 256 "$TMP/home/pets/doraemon/pet.json" "$TMP/home/pets/doraemon/spritesheet.webp")
CODEX_HOME="$TMP/home" DORAEMON_PET_REPO="file://$TMP/broken" sh "$ROOT/install.sh" >/dev/null 2>&1 || true
after=$(shasum -a 256 "$TMP/home/pets/doraemon/pet.json" "$TMP/home/pets/doraemon/spritesheet.webp")
[ "$before" = "$after" ]

CODEX_HOME="$TMP/home" DORAEMON_PET_REPO="file://$ROOT" sh "$ROOT/install.sh" >/dev/null
(cd "$TMP/home/pets/doraemon" && shasum -a 256 -c "$ROOT/checksums.sha256")

echo "installer tests passed"
