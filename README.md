# Godot Claude Code Blueprint (initial scaffold)

This scaffold is an **agent-first** repo bootstrap for a Godot-based online game project.

## What is included
- `CLAUDE.md`
- 6 project subagents in `.claude/agents/`
- `/new-feature` skill in `.claude/skills/new-feature/`
- shared project hooks in `.claude/settings.json`
- validation and build script skeletons
- GitHub Actions workflow skeletons

## First things to customize
1. Replace runner labels:
   - `godot-build`
   - `godot-deploy-staging`
   - `godot-deploy-prod`
2. Set GitHub environment variables:
   - `STAGING_RELEASE_DIR`
   - `PROD_RELEASE_DIR`
3. Install Godot and export templates on the self-hosted runners.
4. Replace `tools/build/deploy_*.sh` with your real deploy logic.
5. Fill in actual game data schemas and smoke tests.

## Suggested first run in Claude Code
1. Open the repo in Claude Code.
2. Run `/status` to verify project settings loaded.
3. Run `/hooks` to confirm hooks are visible.
4. Ask for a feature normally, or run:
   `/new-feature add a beginner daily slime quest that rewards 500 gold`

## Important
This is a **starter skeleton**, not a finished production platform.
Treat it as the minimum repo contract that agents can execute against.
