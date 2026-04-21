#!/usr/bin/env python3
import json
import sys

payload = json.load(sys.stdin)
agent_name = payload.get("matcher", "") or payload.get("subagent_name", "") or "unknown-agent"
print(f"[hook] starting subagent: {agent_name}", file=sys.stderr)
sys.exit(0)
