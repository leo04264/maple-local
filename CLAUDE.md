# Claude Code Project Contract

This repository is operated as an **agent-first feature factory** for a large Godot-based online game.
The human user should only need to describe **what feature they want**. Claude must handle the rest:
spec drafting, planning, implementation, validation, packaging, and deployment handoff.

## Primary operating rule
When the user asks to add, change, or remove a feature, **use `/new-feature`** unless the task is obviously:
- a tiny typo/doc-only fix with no code or data impact
- a read-only question
- a production incident requiring triage before feature work

If the user gives only a rough feature description, do **not** bounce the task back immediately.
Make reasonable assumptions, record them in the spec, and keep moving unless a missing detail blocks correctness or safety.

## Repository shape
- `client-godot/`: Godot client project
- `server-godot/`: headless/dedicated server project
- `backend-api/`: supporting HTTP / ops / admin APIs
- `shared-data/`: gameplay/content/liveops data files
- `tools/validate/`: deterministic validation scripts
- `tools/build/`: build, export, deploy, rollback scripts
- `docs/specs/`: feature specs created by the pipeline
- `.claude/agents/`: specialized subagents
- `.claude/skills/`: reusable skills
- `.github/workflows/`: CI/CD workflows

## Mandatory execution flow
For all feature work:
1. Normalize the feature into a short slug, for example `daily-slime-quest`.
2. Create or update `docs/specs/<slug>.md`.
3. Delegate spec writing to `pm-spec-writer`.
4. Delegate impact analysis to `system-planner`.
5. Delegate code changes to `gameplay-implementer` and/or data changes to `data-content-editor`.
6. Run project validation scripts.
7. Delegate verification and risk review to `qa-reviewer`.
8. If validation passes, prepare build/deploy handoff via `build-publisher`.
9. Return a concise summary with:
   - assumptions made
   - files changed
   - validation results
   - staging / production next action

## Safety rules
- Never read or modify secrets, `.env*`, `secrets/`, or credential files.
- Never deploy to production without explicit human approval.
- Never skip validation after changing gameplay code or shared data.
- Never rewrite large unrelated files when a narrow edit is possible.
- Never bypass hooks, branch protections, or deployment guards.
- Never delete docs/specs for historical features unless explicitly asked.

## Branch and change discipline
- Prefer narrow, reviewable edits.
- Keep one feature per branch.
- Use branch names like:
  - `feature/<slug>`
  - `fix/<slug>`
  - `content/<slug>`
- Keep generated notes in `docs/specs/` and avoid dumping planning notes into unrelated files.

## Data conventions
- Treat `shared-data/` as source-of-truth content.
- Keep data deterministic and schema-friendly.
- When changing data-driven content, update or create validation coverage if possible.
- Prefer additive changes over destructive migrations in early iterations.

## Definition of done
A feature is only “done” when all of the following are true:
- spec exists and matches the implemented scope
- impacted code and/or data changed
- validation scripts passed or known gaps were explicitly documented
- QA notes list what was checked and what still needs manual verification
- build / publish handoff is prepared

## Default response style inside this repo
- Be decisive.
- Prefer direct action over asking for permission repeatedly.
- Surface risk early.
- Keep summaries compact and operational.
