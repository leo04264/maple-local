# Feature: maple-royal-mvp

## Summary
First vertical slice of a MapleRoyals-style 2D side-scrolling MMORPG. Scope this initial milestone to the smallest thing that still *feels* like Maple: one character class walking on a platform map, attacking one monster type, dropping mesos and potions, gaining XP, leveling up. Online multiplayer is **deferred** to a later slice; MVP runs the game loop client-only against a headless authoritative server loop, using the same server code that will later be networked.

## Player-facing behavior
- Start the client, pick a character name, spawn into `henesys-training-ground`.
- WASD / arrow keys to walk, space to jump, Ctrl (or Z) to basic-attack.
- Green Slimes wander on platforms, take damage from basic attacks, die, drop mesos and sometimes a Red Potion.
- HP bar top-left, MP bar below it, EXP bar at the bottom.
- Pick up mesos / items by walking over them (short pickup timer).
- Red Potion in inventory, use it to restore HP.
- Kill enough slimes, level up (stat points auto-assigned for MVP, manual allocation later).
- Die → respawn at town with a small EXP penalty.

## Assumptions
- Engine: **Godot 4.3+** for both client and server. Server runs `--headless`.
- Server is authoritative for combat, loot, XP, inventory. Client predicts movement only.
- MVP is single-player-against-local-server (in-process). Networking is a later slice.
- Pixel art placeholders only; no real Maple art (copyright).
- Data-driven: classes, items, monsters, maps, loot tables all in `shared-data/*.json`.
- Tick rate: server 30 Hz, client renders at display rate.
- Physics: built-in Godot `CharacterBody2D` + tilemap collision, no custom physics engine.
- Persistence: MVP uses a local JSON save file (`user://save.json`). Real DB comes with networking.
- No account system in MVP. Character name only.
- Balance numbers in this doc are starter values; tuning later.

## Scope
- One class: `beginner`
- One map: `henesys-training-ground`
- One monster: `green-slime`
- Two item defs: `meso` (currency), `red-potion` (consumable)
- Core systems:
  - movement + jump + gravity
  - basic attack (melee, short range, 1 hit)
  - HP / MP / EXP / level
  - damage numbers floating text
  - monster AI: wander + aggro on hit
  - loot drop + pickup
  - inventory (grid, 24 slots)
  - potion use
  - death + respawn
  - save / load (local JSON)
- Shared-data schemas + validators updated
- One end-to-end smoke test (server stands up, client connects to in-process server, kills one slime, gains XP)

## Out of scope (explicitly deferred)
- Networking / multiplayer / account system
- Second class, skill trees, skills beyond basic attack
- Multiple maps, portals between maps
- NPCs, dialogue, quests
- Parties, guilds, chat, trade, shop, auction
- Buffs, debuffs, status effects
- Ranged / magic classes and projectiles
- Bosses, dungeons, PQ
- Cash shop, mounts, pets
- PvP
- Art polish, animation beyond 4-frame placeholders
- Sound and music (stubbed)
- Anti-cheat

## Affected areas
- `client-godot/`            — new project
- `server-godot/`            — new project
- `shared-data/classes/`     — `beginner.json`
- `shared-data/monsters/`    — `green-slime.json`
- `shared-data/maps/`        — `henesys-training-ground.json`
- `shared-data/items/`       — `red-potion.json`, `meso.json`
- `shared-data/loot/`        — `green-slime-loot.json`
- `tools/validate/`          — extend validators to cover class / monster / map schemas
- `docs/specs/maple-royal-mvp.md` (this file)

## Acceptance criteria
1. `python3 tools/validate/validate_data.py` passes against all new JSON.
2. `bash tools/validate/smoke_server.sh` boots the server project without script errors.
3. `bash tools/validate/smoke_client.sh` boots the client project without script errors.
4. Client launches → character enters `henesys-training-ground` within 3 seconds.
5. Player can damage a Green Slime with basic attack; slime dies at 0 HP.
6. Slime death drops mesos >=1 and sometimes a Red Potion (per loot table).
7. Picked up mesos increase visible meso count.
8. Red Potion in inventory can be used to restore HP.
9. Killing slimes awards XP and eventually levels the player up (stats increment).
10. Player death triggers respawn at the map's spawn point with HP restored and a small XP decrement.
11. Closing and reopening the client restores character name, level, EXP, mesos, inventory from local save.

## Risks / follow-ups
- Godot version mismatch between devs breaks scenes — pin version in `project.godot` and document in README.
- Server-authoritative combat in the same process is still a correctness test; real latency may surface bugs only when networking is added.
- Loot schema needs to stay compatible when more monsters are added; keep keys generic.
- Save format is intentionally throwaway; budget a migration step when DB replaces it.
- MapleStory IP risk: do not ship any copyrighted art, music, names of proprietary skills, or map names beyond generic fan-tribute terms. Use "Henesys Training Ground" as a placeholder only; swap to original names before any public release.
- Pickup range and i-frames after damage are not defined yet — tune in playtest.

## Next slices (roadmap, non-binding)
1. **Netcode skeleton**: move server out-of-process, add TCP/UDP protocol, login flow, one character per account.
2. **Town + portal**: second map, an NPC, portal transitions.
3. **Quests v0**: single kill quest with reward.
4. **Class expansion**: Warrior + first active skill + skill bar.
5. **More content**: 5 monsters, 1 dungeon, basic equipment + stats.
6. **Party play**: 2-player party, shared XP.
7. **Persistence backend**: replace local JSON with backend-api + database.
