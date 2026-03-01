extends Area2D
class_name DeathArea

@export var player : Player

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.is_dead = true
	elif body is CarryableObject:
		if body.is_package: AchievementsManager.unlock("irresponsibility")
		body.global_position = player.last_save_position
