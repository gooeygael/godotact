class_name Config


const CONFIG_PATH := "res://data/config.json"

static var CELL_SIZE := 128

static func _init() -> void:
		load_config()

static func load_config() -> void:
	var file := FileAccess.open(CONFIG_PATH, FileAccess.READ)
	if file:
		var data = JSON.parse_string(file.get_as_text())
		if typeof(data) == TYPE_DICTIONARY:
			CELL_SIZE = int(data.get("CELL_SIZE", CELL_SIZE))
		file.close()
	else:
		push_error("Failed to open config file: %s" % CONFIG_PATH)
