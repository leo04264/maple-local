class_name Progression extends RefCounted

const DEFAULT_CURVE := [
    15, 34, 57, 92, 135, 194, 264, 349, 450, 573,
    710, 870, 1057, 1272, 1516, 1800, 2115, 2467, 2860, 3293,
]

static func exp_for_next(level: int) -> int:
    if level <= 0:
        return DEFAULT_CURVE[0]
    if level - 1 < DEFAULT_CURVE.size():
        return DEFAULT_CURVE[level - 1]
    return int(DEFAULT_CURVE[-1] * pow(1.15, level - DEFAULT_CURVE.size()))

static func grant_exp(player: Player, amount: int, world: World) -> void:
    if amount <= 0: return
    player.exp += amount
    while player.exp >= exp_for_next(player.level):
        player.exp -= exp_for_next(player.level)
        player.level += 1
        var stats := player.apply_level_gain()
        world.player_leveled.emit(player.id, player.level, stats)
