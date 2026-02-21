extends CarryableObject
class_name Package

@export var interaction_area : Area2D
@export var message : MessageDisplay

func _ready() -> void:
	state = States.Dropped

func _on_area_2d_body_entered(body: Node2D) -> void:
	message.set_message("[E]")

func _on_area_2d_body_exited(body: Node2D) -> void:
	message.hide()
