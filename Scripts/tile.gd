class_name Tile
extends Node2D

@export var grid_pos: Vector2i
var cell_size := Config.CELL_SIZE

@onready var sprite = $Sprite2D

@export var region_index := 0
@export var tile_size := Vector2(128, 128)
@export var tile_texture: Texture2D


func _ready():
	update_visual()


func update_visual():
	sprite.texture = tile_texture
	if tile_texture:
		var columns = int(tile_texture.get_width() / tile_size.x)
		if columns < 1:
			columns = 1
			sprite.region_enabled = true
			sprite.region_rect = Rect2(
			Vector2(region_index % columns, region_index / columns) * tile_size,
			tile_size
		)
		else:
				sprite.region_enabled = false

func update_position():
		position = grid_pos * cell_size
