extends CharacterBody2D
class_name Unit

var cell_size: int = Config.CELL_SIZE
var _grid_pos: Vector2i = Vector2i.ZERO

var team: String = "ally"
var health: int = 100
var attack: int = 10
var move_cd: int = 1
var attack_cd: int = 2
var initiative: int = 3
var cooldown: int = 0
var alive: bool = true

@export var grid_pos: Vector2i:
		get:
				return _grid_pos
		set(value):
				_grid_pos = value
				update_position()

var map: BattleMap  # Set from battle_map.gd on spawn

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


func update_position():
        position = grid_pos * cell_size

func setup(info: Dictionary) -> void:
        grid_pos = Vector2i(info.get("x", 0), info.get("y", 0))
        team = info.get("team", team)
        health = info.get("health", health)
        attack = info.get("attack", attack)
        move_cd = int(info.get("move_cd", move_cd))
        attack_cd = int(info.get("attack_cd", attack_cd))
        initiative = int(info.get("initiative", initiative))

func forward_dir() -> Vector2i:
        return Vector2i(1, 0) if team == "ally" else Vector2i(-1, 0)

func take_turn() -> void:
        if !alive:
                return
        if cooldown > 0:
                cooldown -= 1
		print("%s unit at %s waiting, cooldown %d" % [team, grid_pos, cooldown])
		return

		print("%s unit at %s acting" % [team, grid_pos])
        var target = find_adjacent_enemy()
        if target:
                perform_attack(target)
        else:
                attempt_move_forward()

func find_adjacent_enemy() -> Unit:
        var dirs = [Vector2i(1, 0), Vector2i(-1, 0), Vector2i(0, 1), Vector2i(0, -1)]
        for d in dirs:
                var pos = grid_pos + d
                var enemy: Unit = map.get_unit_at(pos)
                if enemy and enemy.team != team and enemy.alive:
                        return enemy
        return null

func perform_attack(target: Unit) -> void:
        target.receive_damage(attack)
		print("%s unit at %s attacks %s unit at %s" % [team, grid_pos, target.team, target.grid_pos])
        cooldown = attack_cd

func receive_damage(amount: int) -> void:
        health -= amount
		print("%s unit at %s takes %d damage, hp %d" % [team, grid_pos, amount, health])
        if health <= 0:
                die()

func die() -> void:
        alive = false
        map.remove_unit(self)
		print("%s unit at %s has died" % [team, grid_pos])

func attempt_move_forward() -> void:
        var new_pos = grid_pos + forward_dir()
        if map.can_move_to(new_pos):
                map.move_unit(self, new_pos)
		print("%s unit moves to %s" % [team, new_pos])
        cooldown = move_cd
