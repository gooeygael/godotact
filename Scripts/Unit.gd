extends CharacterBody2D
class_name Unit

@export var cell_size := 128
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

func move_to(target: Vector2i):
	grid_pos = target  # Will trigger position update

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and map:
		map.select_unit(self)

func update_position():
	position = grid_pos * cell_size
