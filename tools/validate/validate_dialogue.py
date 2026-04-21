#!/usr/bin/env python3
from __future__ import annotations

import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
TARGET = Path(sys.argv[1]) if len(sys.argv) > 1 else ROOT / "shared-data"

def iter_dialogue_files(base: Path):
    if base.is_file():
        yield base
        return
    for path in base.rglob("*.json"):
        if "dialogue" in path.as_posix():
            yield path

errors: list[str] = []
for path in iter_dialogue_files(TARGET):
    try:
        data = json.loads(path.read_text(encoding="utf-8"))
    except Exception as exc:
        errors.append(f"{path}: invalid JSON: {exc}")
        continue

    if isinstance(data, dict):
        lines = data.get("lines")
        if lines is not None and not isinstance(lines, list):
            errors.append(f"{path}: 'lines' must be a list")

if errors:
    print("\n".join(errors))
    sys.exit(1)

print("validate_dialogue.py: OK")
