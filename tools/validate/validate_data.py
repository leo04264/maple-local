#!/usr/bin/env python3
"""Basic JSON validation skeleton for shared-data files.

Usage:
  python3 tools/validate/validate_data.py
  python3 tools/validate/validate_data.py shared-data/quests/foo.json
"""
from __future__ import annotations

import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
TARGET = Path(sys.argv[1]) if len(sys.argv) > 1 else ROOT / "shared-data"

def validate_file(path: Path) -> list[str]:
    errors: list[str] = []
    if path.suffix != ".json":
        return errors

    try:
        data = json.loads(path.read_text(encoding="utf-8"))
    except Exception as exc:
        return [f"{path}: invalid JSON: {exc}"]

    if isinstance(data, dict) and "id" in data and not data["id"]:
        errors.append(f"{path}: field 'id' must not be empty")

    return errors

def iter_files(target: Path):
    if target.is_file():
        yield target
        return
    for path in target.rglob("*.json"):
        yield path

all_errors: list[str] = []
for file_path in iter_files(TARGET):
    all_errors.extend(validate_file(file_path))

if all_errors:
    print("\n".join(all_errors))
    sys.exit(1)

print("validate_data.py: OK")
