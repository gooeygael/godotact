extends Node2D
class_name GridOverlay

@export var cell_size: Vector2 = Vector2(128, 128)	# match your old tile size
@export var grid_size: Vector2 = Vector2(10, 6)	# columns × rows
@export var line_color: Color = Color(1, 1, 1, 0.1)	# white @ 10% opacity

func _ready() -> void:
	# ensure we draw immediately
	queue_redraw()

func _draw() -> void:
	var w = cell_size.x * grid_size.x
	var h = cell_size.y * grid_size.y

	# vertical lines
	for x in range(int(grid_size.x) + 1):
		var x_pos = x * cell_size.x
		draw_line(
			Vector2(x_pos, 0),
			Vector2(x_pos, h),
			line_color
		)

	# horizontal lines
	for y in range(int(grid_size.y) + 1):
		var y_pos = y * cell_size.y
		draw_line(
			Vector2(0, y_pos),
			Vector2(w, y_pos),
			line_color
		)
