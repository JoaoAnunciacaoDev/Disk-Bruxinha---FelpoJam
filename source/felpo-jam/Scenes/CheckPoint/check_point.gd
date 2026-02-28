extends Area2D

func _on_body_entered(body: Node2D) -> void:
	body.last_save_position = body.global_position
