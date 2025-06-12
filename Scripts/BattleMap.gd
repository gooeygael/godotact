class_name BattleMap
extends Node2D

@export var map_path := "res://data/sample_map.json"
var cell_size: int = Config.CELL_SIZE
var state: GameState


@onready var tile_container = $TileContainer
@onready var unit_container = $UnitContainer

var tile_scene = preload("res://Tile.tscn")
var unit_scene := preload("res://Unit.tscn")

var tiles: Dictionary = {}
var visual_tiles: Dictionary = {}

var selected_unit: Node = null
var movement_range_tiles := []

func _ready():
	state = GameState.new(map_path)
		
	# Offset the map so the first tile is fully visible at the origin
	var half_cell := cell_size / 2
	tile_container.position = Vector2(half_cell, half_cell)
	unit_container.position = Vector2(half_cell, half_cell)

	generate_grid()
	spawn_units()

func get_tile_node_at(pos: Vector2i) -> Node2D:
		if visual_tiles.has(pos):
			return visual_tiles[pos]
		return null

func generate_grid():
	for x in state.grid_width:
		for y in state.grid_height:
			var pos := Vector2i(x, y)
			var data: Dictionary = state.tiles.get(pos, {})
			tiles[pos] = data.duplicate()
			
			var tile_instance = tile_scene.instantiate()
			tile_instance.grid_pos = pos
			tile_instance.cell_size = cell_size
			tile_instance.update_position()
			tile_container.add_child(tile_instance)
			
			visual_tiles[pos] = tile_instance

func world_to_cell(world_pos: Vector2) -> Vector2:
	return Vector2(
		floor(world_pos.x / cell_size.x),
		floor(world_pos.y / cell_size.y)
	)

func cell_to_world(cell: Vector2) -> Vector2:
	return (cell * cell_size) + (cell_size / 2)

	

func spawn_units():
	for info in state.units:
		var unit = unit_scene.instantiate()
		unit.grid_pos = Vector2i(info.get("x", 0), info.get("y", 0))
		unit.cell_size = cell_size
		unit.map = self
		unit_container.add_child(unit)
