#!/usr/bin/env python3
import json
import sys

payload = json.load(sys.stdin)
tool_input = payload.get("tool_input", {})
path = tool_input.get("file_path", "") or tool_input.get("path", "")

protected_markers = [
    ".env",
    ".env.",
    "secrets/",
    ".git/",
    "config/credentials.json",
]

if any(marker in path for marker in protected_markers):
    print(json.dumps({
        "hookSpecificOutput": {
            "hookEventName": "PreToolUse",
            "permissionDecision": "deny",
            "permissionDecisionReason": f"Blocked protected path: {path}"
        }
    }))
    sys.exit(0)

sys.exit(0)
