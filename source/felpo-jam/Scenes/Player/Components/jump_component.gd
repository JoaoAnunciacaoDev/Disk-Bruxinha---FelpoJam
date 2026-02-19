extends Node
class_name JumpComponent

@export var player : Player

@export_category("Jump Data")
@export var jump_force : float
@export var max_jump_count : int
@export var jump_count : int
@export var current_jump_buffer : float
@export var jump_buffer_time : float
@export var current_coyote_time : float
@export var coyote_time : float
@export var max_fall_speed : float
@export var gravity : float

func _process(delta : float) -> void:
	minus_jump_buffer(delta)
	minus_coyote_time(delta)

func jump() -> void:
	minus_jump_count()
	player.play_squash()
	player.velocity.y = jump_force
	
	if not Input.is_action_pressed("jump"):
		cut_velocity_y()

func minus_jump_count() -> void:
	if jump_count > 0:
		jump_count -= 1

func reset_jump_count() -> void:
	jump_count = max_jump_count

func can_jump() -> bool:
	return player.is_on_floor() or jump_count > 0 and has_coyote_time()

func cut_velocity_y() -> void:
	player.velocity.y *= 0.25

func start_jump_buffer() -> void:
	current_jump_buffer = jump_buffer_time

func is_jump_buffering() -> bool:
	return current_jump_buffer > 0

func minus_jump_buffer(delta : float) -> void:
	if current_jump_buffer > 0:
		current_jump_buffer -= delta

func stop_jump_buffer() -> void:
	current_jump_buffer = 0

func start_coyote_time() -> void:
	current_coyote_time = coyote_time

func has_coyote_time() -> bool:
	return current_coyote_time > 0

func minus_coyote_time(delta : float) -> void:
	if current_coyote_time > 0:
		current_coyote_time -= delta

func stop_coyote_time() -> void:
	current_coyote_time = 0
