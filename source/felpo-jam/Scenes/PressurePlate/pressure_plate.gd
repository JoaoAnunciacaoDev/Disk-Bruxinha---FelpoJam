extends Area2D
class_name PressurePlate

signal is_pressed(ia_pressed : bool)

@export var sprite : Sprite2D
@export var sprites : Dictionary[String, Texture2D]

var bodies_interacted : Dictionary[String, PhysicsBody2D]

func _on_body_entered(body: Node2D) -> void:
	if bodies_interacted.is_empty():
		is_pressed.emit(true)
	
	bodies_interacted[body.name] = body
	sprite.texture = sprites["pressed"]

func _on_body_exited(body: Node2D) -> void:
	bodies_interacted.erase(body.name)
	
	if bodies_interacted.is_empty():
		sprite.texture = sprites["unpressed"]
		is_pressed.emit(false)
