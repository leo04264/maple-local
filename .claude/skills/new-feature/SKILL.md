---
name: new-feature
description: End-to-end feature factory for this Godot online game repository. Use whenever the user asks to add, modify, or remove a feature, gameplay behavior, content set, liveops configuration, or supporting system.
allowed-tools:
  - Agent(pm-spec-writer)
  - Agent(system-planner)
  - Agent(gameplay-implementer)
  - Agent(data-content-editor)
  - Agent(qa-reviewer)
  - Agent(build-publisher)
  - Bash(git status *)
  - Bash(git checkout -b *)
  - Bash(mkdir -p *)
  - Bash(python3 tools/validate/*)
  - Bash(bash tools/validate/*)
  - Bash(bash tools/build/*)
  - Edit
  - Write
  - MultiEdit
  - Read
  - Grep
  - Glob
  - LS
---
# Purpose

Run the repository's **feature factory**. The human should only need to describe the desired functionality.
You must orchestrate the rest.

## Input
Treat `$ARGUMENTS` as the raw feature request. If the user did not invoke `/new-feature` explicitly but asked for a feature in normal conversation, you should still follow this playbook.

## Execution contract
Follow these steps in order:

1. **Normalize the request**
   - Create a short slug in kebab-case.
   - Decide whether the feature is primarily:
     - gameplay/code
     - data/content
     - mixed
   - If a critical detail is missing, assume a reasonable default and record it.

2. **Prepare a spec**
   - Ensure `docs/specs/` exists.
   - Create or update `docs/specs/<slug>.md`.
   - Delegate to `pm-spec-writer` to draft the spec.

3. **Plan the implementation**
   - Delegate to `system-planner`.
   - Extract:
     - exact modules to touch
     - exact data paths to touch
     - validation commands to run
     - major risks

4. **Implement**
   - If the change touches code or runtime behavior, delegate to `gameplay-implementer`.
   - If the change touches quests, monsters, items, dialogue, loot, or liveops data, delegate to `data-content-editor`.
   - If both are needed, run them sequentially, not in parallel.

5. **Validate**
   Run whatever applies:
   - `python3 tools/validate/validate_data.py`
   - `python3 tools/validate/validate_dialogue.py`
   - `python3 tools/validate/validate_loot.py`
   - `bash tools/validate/smoke_server.sh`
   - `bash tools/validate/smoke_client.sh`

   If a command is not yet fully wired, record that clearly.

6. **Review**
   - Delegate to `qa-reviewer`.
   - Collect:
     - validation status
     - manual test checklist
     - release risk

7. **Prepare build / publish handoff**
   - Delegate to `build-publisher`.
   - Prefer staging preparation.
   - Never push production without explicit human approval.

8. **Respond**
   Return one concise handoff with:
   - feature slug
   - assumptions
   - changed files
   - validation results
   - staging status
   - exact next human action

## Output template
Use this structure at the end:

```md
Feature:
Assumptions:
Changed files:
Validation:
Staging:
Next human action:
```
