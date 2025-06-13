
extends Node2D
class_name BattleScene

@onready var background: Sprite2D = $background
@onready var battle_map: Node2D = $BattleMap
@onready var grid_overlay: GridOverlay = $"Node2D"

func _ready() -> void:
	_update_layout()
	get_viewport().size_changed.connect(_update_layout)

func _update_layout() -> void:
	_fit_background()
	_fit_grid_area()

func _fit_background() -> void:
	var size: Vector2 = get_viewport_rect().size
	if background.texture:
		var tex_size: Vector2 = background.texture.get_size()
		if tex_size.x != 0 and tex_size.y != 0:
			background.scale = size / tex_size

func _fit_grid_area() -> void:
	var viewport_size: Vector2 = get_viewport_rect().size
	var side_margin: float = viewport_size.x * 0.15
	var bottom_margin: float = viewport_size.y * 0.15
	var bottom_y: float = viewport_size.y - bottom_margin
	var top_y: float = viewport_size.y * 2.0 / 3.0
	var available_width: float = viewport_size.x - side_margin * 2.0
	var available_height: float = bottom_y - top_y

	var grid_size: Vector2 = grid_overlay.grid_size
	var cell_size: float = Config.CELL_SIZE
	var grid_pixel_size: Vector2 = Vector2(grid_size.x * cell_size, grid_size.y * cell_size)

	var scale_factor: float = min(available_width / grid_pixel_size.x, available_height / grid_pixel_size.y)
	battle_map.scale = Vector2.ONE * scale_factor
	grid_overlay.scale = Vector2.ONE * scale_factor

	var scaled_size: Vector2 = grid_pixel_size * scale_factor
	var start_pos: Vector2 = Vector2(side_margin, bottom_y - scaled_size.y)
	battle_map.position = start_pos
	grid_overlay.position = start_pos

