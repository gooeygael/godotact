extends Node
class_name CooldownComponent

var cooldowns: Dictionary = {}

func tick() -> void:
	for name in cooldowns.keys():
		cooldowns[name] -= 1
	for name in cooldowns.keys():
		if cooldowns[name] <= 0:
			cooldowns.erase(name)

func is_ready(name: String) -> bool:
	return !cooldowns.has(name)

func start(name: String, frames: int) -> void:
	cooldowns[name] = frames
