class_name DataLoader extends RefCounted

static func shared_root() -> String:
    return ProjectSettings.globalize_path("res://").path_join("../shared-data")

static func load_json(relative_path: String) -> Variant:
    var full := shared_root().path_join(relative_path)
    var f := FileAccess.open(full, FileAccess.READ)
    if f == null:
        push_error("DataLoader: cannot open %s" % full)
        return null
    var text := f.get_as_text()
    f.close()
    var parsed: Variant = JSON.parse_string(text)
    if parsed == null:
        push_error("DataLoader: invalid JSON at %s" % full)
    return parsed

static func load_all_in(subdir: String) -> Array:
    var results: Array = []
    var full := shared_root().path_join(subdir)
    var d := DirAccess.open(full)
    if d == null:
        push_warning("DataLoader: no such dir %s" % full)
        return results
    d.list_dir_begin()
    var entry := d.get_next()
    while entry != "":
        if not d.current_is_dir() and entry.ends_with(".json"):
            var data: Variant = load_json(subdir.path_join(entry))
            if data != null:
                results.append(data)
        entry = d.get_next()
    d.list_dir_end()
    return results
