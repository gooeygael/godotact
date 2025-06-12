class_name GameState

var grid_width: int
var grid_height: int
var tiles := {}
var units := []

func _init(map_path: String):
	load_map(map_path)

func load_map(path: String) -> void:
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_error("Failed to open map file: %s" % path)
		return
	var data = JSON.parse_string(file.get_as_text())
	file.close()
	grid_width = data.get("width", 0)
	grid_height = data.get("height", 0)

	var blocked := {}
	for b in data.get("blocked_tiles", []):
		blocked[Vector2i(b.get("x", 0), b.get("y", 0))] = true

	tiles.clear()
	for x in grid_width:
		for y in grid_height:
			var pos := Vector2i(x, y)
			tiles[pos] = {
				"walkable": !blocked.has(pos),
				"occupied": false,
				"effect": null
			}

	units = data.get("units", [])
