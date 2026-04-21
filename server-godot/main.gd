extends Node

var world: World

func _ready() -> void:
    print("[server] booting...")
    world = World.new()
    world.name = "World"
    add_child(world)
    world.start()
    print("[server] ready. players=%d maps=%d" % [world.players.size(), world.maps.size()])
    # Smoke hook: spawn a default player so the loop has something to do.
    if OS.has_feature("editor") == false and Engine.is_editor_hint() == false:
        var autospawn := _arg_value("--autospawn")
        if autospawn != "":
            world.spawn_player(autospawn, "beginner")

func _physics_process(delta: float) -> void:
    if world:
        world.tick(delta)

func _arg_value(flag: String) -> String:
    var args := OS.get_cmdline_args()
    for i in range(args.size()):
        if args[i] == flag and i + 1 < args.size():
            return args[i + 1]
    return ""
