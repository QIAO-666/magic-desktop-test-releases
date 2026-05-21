#!/usr/bin/env bash
set -euo pipefail

MANIFEST_URL="https://raw.githubusercontent.com/QIAO-666/magic-desktop-test-releases/main/manifests/latest-mac.json"
TMP_DIR="${TMPDIR:-/tmp}/magic-desktop-update"
mkdir -p "$TMP_DIR"

MANIFEST="$TMP_DIR/latest-mac.json"
curl -L --fail -o "$MANIFEST" "$MANIFEST_URL"

DMG_URL=$(/usr/bin/python3 - "$MANIFEST" <<'PY'
import json, sys
print(json.load(open(sys.argv[1]))["macos"]["latest"]["installer"]["url"])
PY
)
DMG_SHA=$(/usr/bin/python3 - "$MANIFEST" <<'PY'
import json, sys
print(json.load(open(sys.argv[1]))["macos"]["latest"]["installer"]["sha256"])
PY
)
DMG_NAME=$(/usr/bin/python3 - "$MANIFEST" <<'PY'
import json, sys
print(json.load(open(sys.argv[1]))["macos"]["latest"]["installer"]["fileName"])
PY
)

DMG_PATH="$TMP_DIR/$DMG_NAME"
curl -L --fail -o "$DMG_PATH" "$DMG_URL"

ACTUAL_SHA=$(shasum -a 256 "$DMG_PATH" | awk '{print $1}')
if [ "$ACTUAL_SHA" != "$DMG_SHA" ]; then
  echo "sha256 mismatch: expected $DMG_SHA, got $ACTUAL_SHA" >&2
  exit 1
fi

osascript -e 'quit app "Magic"' >/dev/null 2>&1 || true
sleep 1

MOUNT_POINT=$(hdiutil attach "$DMG_PATH" -nobrowse -readonly | awk '/\/Volumes\// {for (i=3;i<=NF;i++) {printf "%s%s", (i==3?"":" "), $i}; print ""; exit}')
if [ -z "$MOUNT_POINT" ]; then
  echo "failed to mount DMG" >&2
  exit 1
fi

APP_SRC=$(find "$MOUNT_POINT" -maxdepth 1 -name "*.app" -type d | head -n 1)
if [ -z "$APP_SRC" ]; then
  hdiutil detach "$MOUNT_POINT" -quiet || true
  echo "no app bundle found in DMG" >&2
  exit 1
fi

APP_DEST="/Applications/$(basename "$APP_SRC")"
rm -rf "$APP_DEST"
ditto "$APP_SRC" "$APP_DEST"
hdiutil detach "$MOUNT_POINT" -quiet
open "$APP_DEST"

echo "installed: $APP_DEST"
