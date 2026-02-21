extends Area2D
class_name NPC

@export var player : Player
@export var sprite : Sprite2D

@export var quotes : Dictionary[String, String]
var is_talking : bool = false

func _process(delta: float) -> void:
	sprite.flip_h = player.position.x < position.x

func active_quote() -> void:
	if is_talking:
		
		return
