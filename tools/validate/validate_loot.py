#!/usr/bin/env python3
from __future__ import annotations

import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
TARGET = Path(sys.argv[1]) if len(sys.argv) > 1 else ROOT / "shared-data"

def iter_loot_files(base: Path):
    if base.is_file():
        yield base
        return
    for path in base.rglob("*.json"):
        p = path.as_posix()
        if "loot" in p or "drop" in p:
            yield path

errors: list[str] = []
for path in iter_loot_files(TARGET):
    try:
        data = json.loads(path.read_text(encoding="utf-8"))
    except Exception as exc:
        errors.append(f"{path}: invalid JSON: {exc}")
        continue

    if isinstance(data, dict) and "entries" in data:
        entries = data["entries"]
        if not isinstance(entries, list):
            errors.append(f"{path}: 'entries' must be a list")
            continue

        total_weight = 0
        for idx, entry in enumerate(entries):
            if not isinstance(entry, dict):
                errors.append(f"{path}: entries[{idx}] must be an object")
                continue
            weight = entry.get("weight", 0)
            if not isinstance(weight, (int, float)) or weight < 0:
                errors.append(f"{path}: entries[{idx}].weight must be >= 0")
            else:
                total_weight += weight

        if total_weight <= 0:
            errors.append(f"{path}: total loot weight must be > 0")

if errors:
    print("\n".join(errors))
    sys.exit(1)

print("validate_loot.py: OK")
