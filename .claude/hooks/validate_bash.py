#!/usr/bin/env python3
import json
import sys

payload = json.load(sys.stdin)
command = payload.get("tool_input", {}).get("command", "")

blocked_fragments = [
    "sudo ",
    " shutdown",
    "reboot",
    "mkfs",
    "rm -rf /",
    "curl ",
    "wget ",
    " | bash",
    "scp ",
    "sftp ",
]

if any(fragment in f" {command}" for fragment in blocked_fragments):
    print(json.dumps({
        "hookSpecificOutput": {
            "hookEventName": "PreToolUse",
            "permissionDecision": "deny",
            "permissionDecisionReason": f"Blocked risky Bash command: {command}"
        }
    }))
    sys.exit(0)

sys.exit(0)
