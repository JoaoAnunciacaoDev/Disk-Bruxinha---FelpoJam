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

@export_category("Stamp Effects Modifier")
@export var speed_multiplier : float = 1.0

func move(delta : float, input_axis : float) -> void:
	player.get_node("Label").text = str(player.move_component.speed_multiplier) + "\n" + str(player.jump_component.jump_multiplier)
	if input_axis != 0:
		if player.is_stamping:
			player.velocity.x = lerp(player.velocity.x, input_axis * speed_stamp * speed_multiplier, \
			acceleration * delta)
		elif player.is_on_floor():
			player.velocity.x = lerp(player.velocity.x, input_axis * speed * speed_multiplier, \
			acceleration * delta)
		else:
			player.velocity.x = lerp(player.velocity.x, input_axis * speed_air * speed_multiplier, \
			acceleration * delta)
	else:
		player.velocity.x = lerp(player.velocity.x, 0.0, friction * delta)

func apply_speed_effect(new_speed_value : float) -> void:
	speed_multiplier = min(3.0, speed_multiplier + new_speed_value)

func minus_speed_effect(speed_bonus : float) -> void:
	speed_multiplier = max(1.0, speed_multiplier - speed_bonus)
