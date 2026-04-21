class_name World extends Node

signal entity_added(scope: String, payload: Dictionary)
signal entity_removed(scope: String, id: int)
signal player_damaged(player_id: int, amount: int, remaining_hp: int)
signal monster_damaged(map_id: String, monster_id: int, amount: int, remaining_hp: int)
signal monster_killed(map_id: String, monster_id: int, killer_player_id: int)
signal loot_spawned(map_id: String, loot_id: int, item_id: String, qty: int, pos: Vector2)
signal loot_picked_up(map_id: String, loot_id: int, player_id: int, item_id: String, qty: int)
signal player_leveled(player_id: int, new_level: int, stats: Dictionary)
signal player_respawned(player_id: int, pos: Vector2)

var classes: Dictionary = {}
var monsters_def: Dictionary = {}
var items_def: Dictionary = {}
var loot_tables: Dictionary = {}
var maps: Dictionary = {}
var players: Dictionary = {}

var _next_player_id: int = 1

func start() -> void:
    _load_all_defs()
    _build_maps()

func _load_all_defs() -> void:
    for c in DataLoader.load_all_in("classes"):
        classes[c.id] = c
    for m in DataLoader.load_all_in("monsters"):
        monsters_def[m.id] = m
    for i in DataLoader.load_all_in("items"):
        items_def[i.id] = i
    for l in DataLoader.load_all_in("loot"):
        loot_tables[l.id] = l

func _build_maps() -> void:
    for map_def in DataLoader.load_all_in("maps"):
        var m := GameMap.new()
        m.name = map_def.id
        m.configure(map_def, self)
        add_child(m)
        maps[map_def.id] = m
        m.populate_initial_spawns()

func tick(delta: float) -> void:
    for m in maps.values():
        m.tick(delta)

func spawn_player(character_name: String, class_id: String = "beginner") -> Player:
    var cls: Variant = classes.get(class_id)
    if cls == null:
        push_error("unknown class %s" % class_id)
        return null
    var p := Player.new()
    p.configure(_next_player_id, character_name, cls, self)
    _next_player_id += 1
    players[p.id] = p
    var map_id: String = cls.get("starting_map", "henesys-training-ground")
    var gm: GameMap = maps.get(map_id)
    if gm:
        gm.enter_player(p)
    entity_added.emit("player", {"map_id": map_id, "player": p.to_wire()})
    return p

func despawn_player(player_id: int) -> void:
    var p: Player = players.get(player_id)
    if p == null: return
    var gm: GameMap = maps.get(p.current_map)
    if gm: gm.leave_player(p)
    players.erase(player_id)
    entity_removed.emit("player", player_id)

func map_for_player(player_id: int) -> GameMap:
    var p: Player = players.get(player_id)
    if p == null: return null
    return maps.get(p.current_map)
