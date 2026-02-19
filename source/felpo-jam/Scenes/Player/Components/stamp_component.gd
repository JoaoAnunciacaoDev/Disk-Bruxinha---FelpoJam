extends Node
class_name StampComponent

const STAMP_SCENE : PackedScene = preload("res://Scenes/Stamp/stamp.tscn")

signal _on_stamp_finished

@export var player : Player

@export_category("Stamp Data")
@export var stamp_time_buffer : float
@export var current_stamp_time : float

@export_category("Node's Reference")
@export var stamp_area_pivot : Node2D
@export var stamp_area : Area2D
@export var collision : CollisionShape2D

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

func active_stamp_area() -> void:
	stamp_area.set_deferred("monitoring", true)

func _on_stamp_area_body_entered(body : Node2D) -> void:
	stamp_area.set_deferred("monitoring", false)
	if body is WorldTileMap:
		var stamped_area : Vector2i = body.get_snapped_position(stamp_area.global_position)
		var stamped_coords : Vector2i = body.get_coords(stamp_area.global_position)
		var data = body.get_cell_tile_data(stamped_coords)
		var is_stampable : bool = false
		if data: 
			is_stampable = data.get_custom_data("is_stampable")
			print("is stampal")
		print(data)
		print(stamped_coords)
		
		if is_stampable:
			var stamp_instance = STAMP_SCENE.instantiate()
			stamp_instance.global_position = stamped_area
			get_tree().root.add_child(stamp_instance)
