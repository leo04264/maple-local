class_name LootRoller extends RefCounted

static func drop(gm: GameMap, monster: Monster, world: World, _killer_id: int) -> void:
    var table_id: String = String(monster.def.get("loot_table_ref", ""))
    if table_id == "": return
    var table: Variant = world.loot_tables.get(table_id)
    if table == null: return
    var entries: Array = table.get("entries", [])
    if entries.is_empty(): return
    var total: int = 0
    for e in entries:
        total += int(e.get("weight", 0))
    if total <= 0: return
    var roll: int = randi() % total
    var running: int = 0
    for e in entries:
        running += int(e.get("weight", 0))
        if roll < running:
            var item_id: String = String(e.item_id)
            if item_id == "__nothing": return
            var qmin: int = int(e.get("qty_min", 1))
            var qmax: int = int(e.get("qty_max", qmin))
            var qty: int = qmin + (randi() % max(1, qmax - qmin + 1))
            var drop_pos := Vector2(monster.pos.x + randi_range(-12, 12), monster.pos.y - 4)
            gm.spawn_loot(item_id, qty, drop_pos)
            return
