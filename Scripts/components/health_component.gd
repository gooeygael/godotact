extends Node
class_name HealthComponent

@export var max_health: int = 10
var current_health: int

signal died

func _ready() -> void:
	current_health = max_health

func is_alive() -> bool:
	return current_health > 0

func take_damage(amount: int) -> void:
	current_health = max(current_health - amount, 0)
	if current_health == 0:
		emit_signal("died")

func heal(amount: int) -> void:
	current_health = min(current_health + amount, max_health)
