#!/usr/bin/env bash
set -euo pipefail

GODOT_BIN="${GODOT_BIN:-godot}"
PROJECT_DIR="${PROJECT_DIR:-client-godot}"
EXPORT_PRESET="${EXPORT_PRESET:-Linux/X11}"
OUT_DIR="${OUT_DIR:-build/client}"
OUT_FILE="${OUT_FILE:-game-client.x86_64}"

mkdir -p "$OUT_DIR"
"$GODOT_BIN" --headless --path "$PROJECT_DIR" --export-release "$EXPORT_PRESET" "$OUT_DIR/$OUT_FILE"
echo "client artifact: $OUT_DIR/$OUT_FILE"
