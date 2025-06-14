extends Node
class_name BasicAttackComponent

@export var unit: Node
@export var cooldown: CooldownComponent
@export var damage: int = 1
@export var range: int = 1
@export var attack_cooldown_frames: int = 1

func can_attack(target: Node) -> bool:
	if target == null:
		return false
	if unit.map == null:
		return false
	if unit.grid_pos.distance_to(target.grid_pos) > range:
		return false
	return cooldown == null or cooldown.is_ready("attack")

func attack(target: Node) -> bool:
	if !can_attack(target):
		return false
	if cooldown:
		cooldown.start("attack", attack_cooldown_frames)
	if target.has_node("HealthComponent"):
		target.get_node("HealthComponent").take_damage(damage)
	return true
