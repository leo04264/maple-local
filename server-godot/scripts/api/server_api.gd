# Public API the client talks to in-process (MVP) and via RPC (future slice).
# Keep methods narrow and ID-based so the shape doesn't change when networking is added.
class_name ServerAPI extends RefCounted

var world: World

func _init(w: World) -> void:
    world = w

func spawn_player(character_name: String, class_id: String = "beginner") -> Dictionary:
    var p := world.spawn_player(character_name, class_id)
    if p == null:
        return {"ok": false, "reason": "unknown_class"}
    return {"ok": true, "player": p.to_wire()}

func despawn_player(player_id: int) -> void:
    world.despawn_player(player_id)

func move_player(player_id: int, new_pos: Vector2, facing: int) -> void:
    var p: Player = world.players.get(player_id)
    if p == null: return
    p.pos = new_pos
    p.facing = facing

func player_basic_attack(player_id: int) -> Dictionary:
    var p: Player = world.players.get(player_id)
    if p == null:
        return {"accepted": false, "reason": "no_player"}
    return CombatSystem.player_basic_attack(p, world)

func pickup_loot(player_id: int, loot_id: int) -> bool:
    var p: Player = world.players.get(player_id)
    if p == null: return false
    var gm: GameMap = world.map_for_player(player_id)
    if gm == null: return false
    return gm.try_pickup(p, loot_id)

func use_item(player_id: int, item_id: String) -> bool:
    var p: Player = world.players.get(player_id)
    if p == null: return false
    return Inventory.use_item(p, item_id, world)

func snapshot_map(map_id: String) -> Dictionary:
    var gm: GameMap = world.maps.get(map_id)
    if gm == null:
        return {}
    var monsters: Array = []
    for m in gm.monsters.values():
        monsters.append(m.to_wire())
    var players: Array = []
    for pl in gm.players_here.values():
        players.append(pl.to_wire())
    return {
        "map_id": gm.id,
        "monsters": monsters,
        "players": players,
        "loot": gm.loot_on_ground.values(),
    }
