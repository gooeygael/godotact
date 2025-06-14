extends Node
class_name PriorityComponent

@export var move_before_attack: bool = false

func should_move_before_attack() -> bool:
	return move_before_attack
