extends Node
class_name MoveComponent

@export var player : Player

@export_category("Movement Data")
@export var max_speed : float
@export var speed : float
@export var speed_air : float
@export var speed_stamp : float
@export var acceleration : float
@export var friction : float

func move(delta : float, input_axis : float) -> void:
	if input_axis != 0:
		if player.is_stamping:
			player.velocity.x = lerp(player.velocity.x, input_axis * speed_stamp, \
			acceleration * delta)
		elif player.is_on_floor():
			player.velocity.x = lerp(player.velocity.x, input_axis * speed, \
			acceleration * delta)
		else:
			player.velocity.x = lerp(player.velocity.x, input_axis * speed_air, \
			acceleration * delta)
	else:
		player.velocity.x = lerp(player.velocity.x, 0.0, friction * delta)
