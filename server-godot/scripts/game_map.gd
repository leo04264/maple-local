class_name GameMap extends Node

var id: String
var display_name: String
var size: Vector2 = Vector2.ZERO
var spawn_point: Vector2 = Vector2.ZERO
var respawn_point: Vector2 = Vector2.ZERO
var platforms: Array = []
var monster_spawn_defs: Array = []

var monsters: Dictionary = {}
var players_here: Dictionary = {}
var loot_on_ground: Dictionary = {}

var _world: World
var _next_monster_id: int = 1
var _next_loot_id: int = 1
var _respawn_queue: Array = []

func configure(def: Dictionary, world: World) -> void:
    id = def.id
    display_name = def.get("display_name", id)
    size = Vector2(def.size.w, def.size.h)
    spawn_point = Vector2(def.spawn_point.x, def.spawn_point.y)
    respawn_point = Vector2(def.respawn_point.x, def.respawn_point.y)
    platforms = def.get("platforms", [])
    monster_spawn_defs = def.get("monster_spawns", [])
    _world = world

func populate_initial_spawns() -> void:
    for s in monster_spawn_defs:
        var n: int = int(s.get("count", 1))
        for i in n:
            _spawn_monster(s.monster_id, Vector2(s.x, s.y))

func _spawn_monster(def_id: String, pos: Vector2) -> void:
    var def: Variant = _world.monsters_def.get(def_id)
    if def == null: return
    var m := Monster.new()
    m.configure(_next_monster_id, def, pos)
    _next_monster_id += 1
    monsters[m.id] = m
    _world.entity_added.emit("monster", {"map_id": id, "monster": m.to_wire()})

func tick(delta: float) -> void:
    var t := Time.get_ticks_msec()
    for m in monsters.values():
        m.tick(delta, self)
    var pending: Array = []
    for entry in _respawn_queue:
        if t >= int(entry.when_ms):
            _spawn_monster(entry.def_id, Vector2(entry.pos_x, entry.pos_y))
        else:
            pending.append(entry)
    _respawn_queue = pending

func enter_player(p: Player) -> void:
    p.pos = spawn_point
    p.current_map = id
    players_here[p.id] = p

func leave_player(p: Player) -> void:
    players_here.erase(p.id)

func remove_monster(monster_id: int, killer_player_id: int) -> void:
    var m: Monster = monsters.get(monster_id)
    if m == null: return
    monsters.erase(monster_id)
    _world.entity_removed.emit("monster", monster_id)
    _world.monster_killed.emit(id, monster_id, killer_player_id)
    _respawn_queue.append({
        "def_id": String(m.def.id),
        "pos_x": m.spawn_pos.x,
        "pos_y": m.spawn_pos.y,
        "when_ms": Time.get_ticks_msec() + int(m.def.get("respawn_seconds", 8)) * 1000,
    })
    LootRoller.drop(self, m, _world, killer_player_id)

func ground_y_at(x: float) -> float:
    var best: float = size.y
    for p in platforms:
        if x >= p.x and x <= p.x + p.w and p.y < best:
            best = p.y
    return best

func spawn_loot(item_id: String, qty: int, pos: Vector2) -> void:
    var lid := _next_loot_id
    _next_loot_id += 1
    loot_on_ground[lid] = {
        "id": lid,
        "item_id": item_id,
        "qty": qty,
        "pos": pos,
        "spawned_ms": Time.get_ticks_msec(),
    }
    _world.loot_spawned.emit(id, lid, item_id, qty, pos)

func try_pickup(player: Player, loot_id: int) -> bool:
    var loot: Variant = loot_on_ground.get(loot_id)
    if loot == null: return false
    var d := Vector2(loot.pos.x, loot.pos.y).distance_to(player.pos)
    if d > 48.0:
        return false
    loot_on_ground.erase(loot_id)
    Inventory.add_item(player, String(loot.item_id), int(loot.qty), _world.items_def)
    _world.loot_picked_up.emit(id, loot_id, player.id, String(loot.item_id), int(loot.qty))
    return true

func monsters_in_range(origin: Vector2, facing: int, w: float, h: float) -> Array:
    var results: Array = []
    var rect := Rect2(
        Vector2(origin.x + (0.0 if facing >= 0 else -w), origin.y - h * 0.5),
        Vector2(w, h))
    for m in monsters.values():
        if rect.has_point(m.pos):
            results.append(m)
    return results
