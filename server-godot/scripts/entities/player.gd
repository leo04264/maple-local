class_name Player extends RefCounted

var id: int
var character_name: String
var class_id: String
var level: int = 1
var exp: int = 0
var hp_max: int = 50
var hp: int = 50
var mp_max: int = 5
var mp: int = 5
var atk: int = 4
var def_stat: int = 1
var move_speed: float = 180.0
var jump_speed: float = 360.0
var basic_attack: Dictionary = {}
var pos: Vector2 = Vector2.ZERO
var facing: int = 1
var current_map: String = ""
var inventory: Dictionary = {}   # item_id -> qty (meso stacks into this too)
var last_attack_ms: int = 0
var last_damage_ms: int = 0
var _cls: Dictionary
var _world: World

func configure(p_id: int, p_name: String, cls: Dictionary, world: World) -> void:
    id = p_id
    character_name = p_name
    _cls = cls
    _world = world
    class_id = String(cls.id)
    var base: Dictionary = cls.get("base_stats", {})
    hp_max = int(base.get("hp", 50)); hp = hp_max
    mp_max = int(base.get("mp", 5));  mp = mp_max
    atk = int(base.get("atk", 4))
    def_stat = int(base.get("def", 1))
    move_speed = float(base.get("move_speed", 180))
    jump_speed = float(base.get("jump_speed", 360))
    basic_attack = cls.get("basic_attack", {})
    for entry in cls.get("starting_inventory", []):
        inventory[String(entry.item_id)] = int(entry.get("qty", 1))

func apply_level_gain() -> Dictionary:
    var gain: Dictionary = _cls.get("per_level_gain", {})
    hp_max += int(gain.get("hp", 0))
    mp_max += int(gain.get("mp", 0))
    atk    += int(gain.get("atk", 0))
    def_stat += int(gain.get("def", 0))
    hp = hp_max
    mp = mp_max
    return current_stats()

func current_stats() -> Dictionary:
    return {
        "level": level, "exp": exp,
        "hp": hp, "hp_max": hp_max,
        "mp": mp, "mp_max": mp_max,
        "atk": atk, "def": def_stat,
    }

func to_wire() -> Dictionary:
    return {
        "id": id,
        "name": character_name,
        "class_id": class_id,
        "pos": {"x": pos.x, "y": pos.y},
        "facing": facing,
        "stats": current_stats(),
        "inventory": inventory.duplicate(),
        "current_map": current_map,
    }
