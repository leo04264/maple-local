#!/usr/bin/env bash
set -euo pipefail

GODOT_BIN="${GODOT_BIN:-godot}"
PROJECT_DIR="${PROJECT_DIR:-server-godot}"
EXPORT_PRESET="${EXPORT_PRESET:-Linux Server}"
OUT_DIR="${OUT_DIR:-build/server}"
OUT_FILE="${OUT_FILE:-game-server.x86_64}"

mkdir -p "$OUT_DIR"
"$GODOT_BIN" --headless --path "$PROJECT_DIR" --export-release "$EXPORT_PRESET" "$OUT_DIR/$OUT_FILE"
echo "server artifact: $OUT_DIR/$OUT_FILE"
