extends Node
class_name MoveComponent

@export var player : Player

@export_category("Movement Data")
@export var max_speed : float
@export var speed : float
@export var acceleration : float
@export var friction : float
@export var gravity : float

func move(delta : float, input_axis : float) -> void:
	if input_axis != 0:
		player.velocity.x = lerp(player.velocity.x, input_axis * max_speed, \
		acceleration * delta)
	else:
		player.velocity.x = lerp(player.velocity.x, 0.0, friction * delta)
