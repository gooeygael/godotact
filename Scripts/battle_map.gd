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
var units: Array = []
var units_by_pos: Dictionary = {}
var battle_timer: Timer
var rng := RandomNumberGenerator.new()


func _ready():
        state = GameState.new(map_path)
		
	# Offset the map so the first tile is fully visible at the origin
	var half_cell := cell_size / 2
	tile_container.position = Vector2(half_cell, half_cell)
	unit_container.position = Vector2(half_cell, half_cell)

        generate_grid()
        spawn_units()
        rng.seed = 1
        battle_timer = Timer.new()
        battle_timer.wait_time = 6.0
        battle_timer.one_shot = false
        add_child(battle_timer)
        battle_timer.timeout.connect(_on_battle_frame)
        battle_timer.start()

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

func world_to_cell(world_pos: Vector2) -> Vector2i:
	return Vector2i(
		floor(world_pos.x / cell_size),
		floor(world_pos.y / cell_size)
	)

func cell_to_world(cell: Vector2i) -> Vector2:
        return Vector2(cell) * cell_size + Vector2.ONE * (cell_size / 2.0)
		

func spawn_units():
        for info in state.units:
                var unit: Unit = unit_scene.instantiate()
                unit.cell_size = cell_size
                unit.map = self
                unit.setup(info)
                unit_container.add_child(unit)
                units.append(unit)
                tiles[unit.grid_pos]["occupied"] = true
                units_by_pos[unit.grid_pos] = unit

	print("Spawned %s unit at %s" % [unit.team, unit.grid_pos])


func get_unit_at(pos: Vector2i) -> Unit:
        return units_by_pos.get(pos)

func can_move_to(pos: Vector2i) -> bool:
        if !tiles.has(pos):
                return false
        var data = tiles[pos]
        return data.get("walkable", true) and !data.get("occupied", false)

func move_unit(unit: Unit, new_pos: Vector2i) -> void:
        units_by_pos.erase(unit.grid_pos)
        tiles[unit.grid_pos]["occupied"] = false
        unit.grid_pos = new_pos
        tiles[new_pos]["occupied"] = true
        units_by_pos[new_pos] = unit

func remove_unit(unit: Unit) -> void:
        units_by_pos.erase(unit.grid_pos)
        if tiles.has(unit.grid_pos):
                tiles[unit.grid_pos]["occupied"] = false
        units.erase(unit)
        unit.queue_free()

func _sort_units(a: Unit, b: Unit) -> bool:
        if a.initiative == b.initiative:
                return rng.randi() % 2 == 0
        return a.initiative > b.initiative

func _on_battle_frame() -> void:
	print("=== Battle Frame ===")
        if check_victory():
                return
        var active: Array = []
        for u in units:
                if u.alive:
                        active.append(u)
        active.sort_custom(self, "_sort_units")
        for u in active:
                u.take_turn()
        check_victory()

func check_victory() -> bool:
        var ally := false
        var enemy := false
        for u in units:
                if u.alive:
                        if u.team == "ally":
                                ally = true
                        else:
                                enemy = true
        if !ally or !enemy:
                if battle_timer:
                        battle_timer.stop()
                print("Battle finished")
                return true
        return false
