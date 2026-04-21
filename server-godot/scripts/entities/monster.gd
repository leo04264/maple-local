class_name Monster extends RefCounted

var id: int
var def: Dictionary
var pos: Vector2 = Vector2.ZERO
var spawn_pos: Vector2 = Vector2.ZERO
var hp: int = 0
var hp_max: int = 0
var facing: int = 1
var state: String = "wander"   # wander | aggro | dead
var target_player_id: int = 0
var _patrol_min_x: float
var _patrol_max_x: float
var _last_think_ms: int = 0

func configure(m_id: int, m_def: Dictionary, p: Vector2) -> void:
    id = m_id
    def = m_def
    pos = p
    spawn_pos = p
    hp_max = int(def.stats.hp)
    hp = hp_max
    var patrol: float = float(def.ai.get("patrol_range", 120))
    _patrol_min_x = pos.x - patrol * 0.5
    _patrol_max_x = pos.x + patrol * 0.5

func tick(delta: float, gm: GameMap) -> void:
    if state == "dead": return
    var speed: float = float(def.stats.move_speed)
    pos.x += facing * speed * delta
    if pos.x < _patrol_min_x:
        pos.x = _patrol_min_x; facing = 1
    elif pos.x > _patrol_max_x:
        pos.x = _patrol_max_x; facing = -1
    pos.y = gm.ground_y_at(pos.x)

func take_damage(amount: int) -> int:
    hp = max(0, hp - amount)
    if hp <= 0:
        state = "dead"
    return hp

func to_wire() -> Dictionary:
    return {
        "id": id,
        "def_id": String(def.id),
        "pos": {"x": pos.x, "y": pos.y},
        "facing": facing,
        "hp": hp, "hp_max": hp_max,
        "state": state,
    }
