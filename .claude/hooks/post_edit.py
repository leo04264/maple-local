#!/usr/bin/env python3
import json
import os
import subprocess
import sys
from pathlib import Path

payload = json.load(sys.stdin)
tool_input = payload.get("tool_input", {})
path = tool_input.get("file_path") or tool_input.get("path")
if not path:
    sys.exit(0)

project_dir = Path(os.environ.get("CLAUDE_PROJECT_DIR", ".")).resolve()
file_path = Path(path)

def run(cmd):
    try:
        subprocess.run(cmd, cwd=project_dir, check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
    except subprocess.CalledProcessError as exc:
        print(exc.stderr or exc.stdout, file=sys.stderr)

posix_path = file_path.as_posix()

if posix_path.startswith("shared-data/"):
    run(["python3", "tools/validate/validate_data.py", posix_path])

    if "/dialogue/" in posix_path or posix_path.endswith("dialogue.json"):
        run(["python3", "tools/validate/validate_dialogue.py", posix_path])

    if "/loot/" in posix_path or "loot" in file_path.name:
        run(["python3", "tools/validate/validate_loot.py", posix_path])

sys.exit(0)
