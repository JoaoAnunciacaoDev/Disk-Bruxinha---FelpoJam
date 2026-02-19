extends Node
class_name StampComponent

signal _on_stamp_finished

@export var player : Player

@export_category("Stamp Data")
@export var stamp_time_buffer : float
@export var current_stamp_time : float

var stamp_color : String = ""

func _process(delta : float) -> void:
	minus_stamp_time(delta)

func start_stamp_buffer(new_stamp_color : String) -> void:
	stamp_color = new_stamp_color
	current_stamp_time = stamp_time_buffer

func is_stamp_buffering() -> bool:
	return current_stamp_time > 0

func minus_stamp_time(delta : float) -> void:
	if current_stamp_time > 0:
		current_stamp_time -= delta

func stop_stamp_buffer() -> void:
	current_stamp_time = 0

func facing_wall() -> bool:
	return player.detect_wall_raycast.is_colliding()
