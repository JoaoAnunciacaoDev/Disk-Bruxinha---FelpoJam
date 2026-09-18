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
var active_speed_effects : Dictionary = {}

@export_category("Node's Reference")
@export var ghost_spawner : GhostSpawner
@export var jump_component : JumpComponent

func move(delta : float, input_axis : float) -> void:
	if not player.can_move: return
	
	if speed_multiplier > 1.0: 
		ghost_spawner.startSpawn("Carimbo Azul")
	elif jump_component.jump_multiplier == 1.0:
		ghost_spawner.stopSpawn()
	
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

func apply_speed_effect(source_id : int, new_speed_value : float) -> void:
	active_speed_effects[source_id] = new_speed_value
	_refresh_speed_effects()

func remove_speed_effect(source_id : int) -> void:
	active_speed_effects.erase(source_id)
	_refresh_speed_effects()

func _refresh_speed_effects() -> void:
	var total_bonus := 0.0
	for bonus in active_speed_effects.values():
		total_bonus += float(bonus)

	speed_multiplier = minf(3.0, 1.0 + total_bonus)
	player.icon_manager.set_icon_count("Carimbo Azul", active_speed_effects.size())
