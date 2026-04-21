class_name CombatSystem extends RefCounted

static func player_basic_attack(player: Player, world: World) -> Dictionary:
    var now := Time.get_ticks_msec()
    var cd: int = int(player.basic_attack.get("cooldown_ms", 350))
    if now - player.last_attack_ms < cd:
        return {"accepted": false, "reason": "on_cooldown"}
    player.last_attack_ms = now
    var gm: GameMap = world.maps.get(player.current_map)
    if gm == null:
        return {"accepted": false, "reason": "no_map"}
    var hitbox: Dictionary = player.basic_attack.get("hitbox", {"w": 56, "h": 48})
    var range_w: float = float(hitbox.get("w", 56))
    var range_h: float = float(hitbox.get("h", 48))
    var targets := gm.monsters_in_range(player.pos, player.facing, range_w, range_h)
    var mult: float = float(player.basic_attack.get("damage_multiplier", 1.0))
    var results: Array = []
    for m in targets:
        if m.state == "dead": continue
        var raw: int = max(1, int(round(player.atk * mult)))
        var blocked: int = int(m.def.stats.get("def", 0))
        var dmg: int = max(1, raw - blocked)
        var remaining: int = m.take_damage(dmg)
        results.append({"monster_id": m.id, "damage": dmg, "remaining_hp": remaining})
        world.monster_damaged.emit(gm.id, m.id, dmg, remaining)
        if remaining == 0:
            var xp: int = int(m.def.get("exp_reward", 0))
            gm.remove_monster(m.id, player.id)
            Progression.grant_exp(player, xp, world)
    return {"accepted": true, "targets": results}

static func monster_hit_player(monster: Monster, player: Player, world: World) -> void:
    var raw: int = max(1, int(monster.def.stats.atk))
    var dmg: int = max(1, raw - player.def_stat)
    player.hp = max(0, player.hp - dmg)
    world.player_damaged.emit(player.id, dmg, player.hp)
    if player.hp == 0:
        _respawn(player, world)

static func _respawn(player: Player, world: World) -> void:
    var gm: GameMap = world.maps.get(player.current_map)
    if gm:
        player.pos = gm.respawn_point
    player.hp = player.hp_max
    var penalty: int = int(player.exp * 0.05)
    player.exp = max(0, player.exp - penalty)
    world.player_respawned.emit(player.id, player.pos)
