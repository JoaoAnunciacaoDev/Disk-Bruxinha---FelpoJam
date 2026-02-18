extends Node
class_name StampComponent

@export var player : Player

@export_category("Stamp Data")
@export var stamp_time_buffer : float
@export var current_stamp_time : float

func _process(delta : float) -> void:
	minus_stamp_time(delta)

func start_stamp_buffer() -> void:
	current_stamp_time = stamp_time_buffer

func is_stamp_buffering() -> bool:
	return current_stamp_time > 0

func minus_stamp_time(delta : float) -> void:
	if current_stamp_time > 0:
		current_stamp_time -= delta

func stop_stamp_buffer() -> void:
	current_stamp_time = 0
