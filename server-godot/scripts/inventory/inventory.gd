class_name Inventory extends RefCounted

const SLOT_LIMIT := 24

static func add_item(player: Player, item_id: String, qty: int, items_def: Dictionary) -> bool:
    if qty <= 0: return false
    var existing: int = int(player.inventory.get(item_id, 0))
    if existing == 0 and player.inventory.size() >= SLOT_LIMIT:
        return false
    player.inventory[item_id] = existing + qty
    return true

static func remove_item(player: Player, item_id: String, qty: int) -> bool:
    var have: int = int(player.inventory.get(item_id, 0))
    if have < qty: return false
    var left: int = have - qty
    if left == 0:
        player.inventory.erase(item_id)
    else:
        player.inventory[item_id] = left
    return true

static func use_item(player: Player, item_id: String, world: World) -> bool:
    var have: int = int(player.inventory.get(item_id, 0))
    if have <= 0: return false
    var def: Variant = world.items_def.get(item_id)
    if def == null: return false
    if String(def.get("type", "")) != "consumable": return false
    var effect: Dictionary = def.get("use_effect", {})
    var kind: String = String(effect.get("kind", ""))
    if kind == "restore_hp":
        var amount: int = int(effect.get("amount", 0))
        player.hp = min(player.hp_max, player.hp + amount)
    elif kind == "restore_mp":
        var amount: int = int(effect.get("amount", 0))
        player.mp = min(player.mp_max, player.mp + amount)
    else:
        return false
    return remove_item(player, item_id, 1)
