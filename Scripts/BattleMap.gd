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



func highlight_range(center: Vector2i, range: int):
		for x in range(range * 2 + 1):
				for y in range(range * 2 + 1):
						var pos = center + Vector2i(x - range, y - range)
						if tiles.has(pos):
								var tile_node = get_tile_node_at(pos)
								if tile_node:
										tile_node.highlight()

func get_tile_node_at(pos: Vector2i) -> Node2D:
		if visual_tiles.has(pos):
			return visual_tiles[pos]
		return null

	
func show_movement_range(origin: Vector2i, range: int):
	clear_highlights()

	var open := [origin]
	var visited := {}
	var directions := [Vector2i.UP, Vector2i.DOWN, Vector2i.LEFT, Vector2i.RIGHT]

	while open.size() > 0:
		var current = open.pop_front()
		if visited.has(current):
			continue
		visited[current] = true

		var distance = abs(current.x - origin.x) + abs(current.y - origin.y)
		if distance > range:
			continue

		var tile_node = get_tile_node_at(current)
		if tile_node:
			tile_node.highlight()
			movement_range_tiles.append(tile_node)

		for dir in directions:
			var neighbor = current + dir
			if tiles.has(neighbor) and tiles[neighbor]["walkable"]:
				open.append(neighbor)


func clear_highlights():
	for tile in movement_range_tiles:
		tile.reset()
	movement_range_tiles.clear()
	
	
func select_unit(unit: Node):
	selected_unit = unit
	show_movement_range(unit.grid_pos, unit.move_range)
	


func generate_grid():
	for x in state.grid_width:
	for y in state.grid_height:
	var pos := Vector2i(x, y)
	var data := state.tiles.get(pos, {})
	tiles[pos] = data.duplicate()
	
	var tile_instance = tile_scene.instantiate()
	tile_instance.grid_pos = pos
	tile_instance.cell_size = cell_size
	tile_instance.update_position()
	tile_container.add_child(tile_instance)
	
	visual_tiles[pos] = tile_instance


func to_world(grid_pos: Vector2i) -> Vector2:
	return Vector2(grid_pos.x, grid_pos.y) * cell_size

func to_grid(world_pos: Vector2) -> Vector2i:
	return Vector2i(floor(world_pos.x / cell_size), floor(world_pos.y / cell_size))
	

	func spawn_units():
	for info in state.units:
	var unit = unit_scene.instantiate()
	unit.grid_pos = Vector2i(info.get("x", 0), info.get("y", 0))
	unit.cell_size = cell_size
	unit.map = self
	unit_container.add_child(unit)
