class_name Tile
extends Node2D

@export var default_color: Color = Color.DARK_GRAY
@export var highlight_color: Color = Color.YELLOW
@export var grid_pos: Vector2i
@export var cell_size: int = 128

@onready var sprite = $Sprite2D

@export var region_index := 0
@export var tile_size := Vector2(128, 128)
@export var tile_texture: Texture2D


func _ready():
	update_visual()
	reset()

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
	sprite.scale = Vector2.ONE
	sprite.position = Vector2.ZERO


func highlight():
	sprite.modulate = highlight_color

func reset():
	sprite.modulate = default_color


func update_position():
	position = grid_pos * cell_size
