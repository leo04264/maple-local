#!/usr/bin/env bash
set -euo pipefail

GODOT_BIN="${GODOT_BIN:-godot}"
PROJECT_DIR="${PROJECT_DIR:-server-godot}"

if ! command -v "$GODOT_BIN" >/dev/null 2>&1; then
  echo "smoke_server.sh: GODOT_BIN not found ($GODOT_BIN). Set GODOT_BIN or install Godot on the runner."
  exit 1
fi

echo "[smoke_server] checking headless server project at $PROJECT_DIR"
"$GODOT_BIN" --headless --path "$PROJECT_DIR" --quit
echo "[smoke_server] OK"
