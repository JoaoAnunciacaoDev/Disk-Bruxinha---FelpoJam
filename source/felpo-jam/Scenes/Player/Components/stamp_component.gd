extends Node
class_name StampComponent

const STAMP_SCENE : PackedScene = preload("res://Scenes/Stamp/stamp.tscn")

signal _on_stamp_finished

@export var player : Player

@export_category("Stamp Data")
@export var stamp_time_buffer : float
@export var current_stamp_time : float

@export_category("Node's Reference")
@export var detect_ground_raycast : RayCast2D
@export var detect_wall_raycast : RayCast2D

var stamp_color : String = ""
var can_stamp : bool = false

func _process(delta : float) -> void:
	minus_stamp_time(delta)
	
	if can_stamp:
		if detect_wall_raycast.is_colliding():
				
			var body = detect_wall_raycast.get_collider()
			
			if detect_wall_raycast.get_collider() is WorldTileMap:
				
				var collision_point : Vector2 = detect_wall_raycast.get_collision_point()
				var stamped_point : Vector2i
				
				if detect_wall_raycast.scale.x < 0.0:
					stamped_point = body.get_snapped_position(collision_point) + Vector2i(-32, 0)
				else:
					stamped_point = body.get_snapped_position(collision_point)
				
				var stamped_coords : Vector2i = body.get_coords(stamped_point)
				var data = body.get_cell_tile_data(stamped_coords)
				var is_stampable : bool = false
				
				if data: 
					is_stampable = data.get_custom_data("is_stampable")
					print("is stampal")
				
				if is_stampable:
					can_stamp = false
					var stamp_instance = STAMP_SCENE.instantiate()
					stamp_instance.global_position = stamped_point
					get_tree().root.add_child(stamp_instance)
		
		if detect_ground_raycast.is_colliding():
				
			var body = detect_ground_raycast.get_collider()
			
			if detect_ground_raycast.get_collider() is WorldTileMap:
				
				var collision_point : Vector2 = detect_ground_raycast.get_collision_point()
				var stamped_point : Vector2i
				
				if detect_ground_raycast.scale.x < 0.0:
					stamped_point = body.get_snapped_position(collision_point)
				else:
					stamped_point = body.get_snapped_position(collision_point)
				
				var stamped_coords : Vector2i = body.get_coords(stamped_point)
				var data = body.get_cell_tile_data(stamped_coords)
				var is_stampable : bool = false
				
				if data: 
					is_stampable = data.get_custom_data("is_stampable")
					print("is stampal")
				
				if is_stampable:
					can_stamp = false
					var stamp_instance = STAMP_SCENE.instantiate()
					stamp_instance.global_position = stamped_point
					get_tree().root.add_child(stamp_instance)

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
	return detect_wall_raycast.is_colliding()

func active_stamp_area() -> void:
	can_stamp = true

func desactive_stamp_area() -> void:
	can_stamp = false

func stamp_area_to_ground() -> void:
	player.stamping_sprite.position.x = detect_wall_raycast.target_position.x
	player.stamping_sprite.position.y = 0.0

func stamp_area_to_wall() -> void:
	player.stamping_sprite.position.x = detect_wall_raycast.target_position.x
	player.stamping_sprite.position.y = detect_wall_raycast.target_position.y - 32.0
