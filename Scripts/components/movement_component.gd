extends Node
class_name MovementComponent

@export var unit: Node
@export var cooldown: CooldownComponent
@export var move_cooldown_frames: int = 1

func request_move(delta: Vector2i) -> bool:
	if cooldown and !cooldown.is_ready("move"):
		return false
	if unit == null:
		return false
	var target := unit.grid_pos + delta
	if unit.map and unit.map.tiles.has(target):
		var tile := unit.map.tiles[target]
		if tile.get("walkable", true):
			unit.grid_pos = target
			if cooldown:
				cooldown.start("move", move_cooldown_frames)
			return true
	return false
