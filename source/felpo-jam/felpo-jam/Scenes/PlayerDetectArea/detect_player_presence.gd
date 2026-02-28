extends Area2D
class_name PlayerDetectArea

@onready var parent : HiddenTileMap = get_parent()

var revealed : bool = false

func _on_body_entered(body: Node2D) -> void:
	if not revealed:
		revealed = true
		parent.anim_player.queue("fade_out")

func _on_body_exited(body: Node2D) -> void:
	if revealed:
		revealed = false
		parent.anim_player.queue("fade_in")
