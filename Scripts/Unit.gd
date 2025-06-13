extends CharacterBody2D
class_name Unit

var cell_size: int = Config.CELL_SIZE
var _grid_pos: Vector2i = Vector2i.ZERO

@export var grid_pos: Vector2i:
		get:
				return _grid_pos
		set(value):
				_grid_pos = value
				update_position()

var map: BattleMap  # Set from BattleMap.gd on spawn

@onready var sprite = $Sprite2D

func _ready():
	update_position()
	fit_to_tile()
	
func fit_to_tile():
	if sprite.texture:
		var tex_size = sprite.texture.get_size()
		if tex_size.x != 0 and tex_size.y != 0:
			var scale_x = cell_size / tex_size.x
			var scale_y = cell_size / tex_size.y
			sprite.scale = Vector2(scale_x, scale_y)

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and map:
		map.select_unit(self)

func update_position():
	position = grid_pos * cell_size
