extends Node
class_name StampComponent

const STAMP_SCENE : PackedScene = preload("res://Scenes/Stamp/stamp.tscn")

signal _on_stamp_finished

@export var player : Player

@export_category("Stamp Data")
@export var stamp_time_buffer : float
@export var current_stamp_time : float
@export var cooldown_time : float
@export var current_cooldown_time : float

@export_category("Node's Reference")
@export var detect_ground_raycast : RayCast2D
@export var detect_wall_raycast : RayCast2D
@export var crosshair : Sprite2D

var stamp_color : String = ""
var can_stamp : bool = false
var locals_stamped : Dictionary[Vector2i, StampInstance]

func _process(delta : float) -> void:
	minus_stamp_time(delta)
	minus_cooldown_time(delta)
	
	if is_in_cooldown(): return
	
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
				
				if stamped_point in locals_stamped:
					remove_stamp(stamped_point)
					return
				
				var stamped_coords : Vector2i = body.get_coords(stamped_point)
				var data = body.get_cell_tile_data(stamped_coords)
				var is_stampable : bool = false
				
				if data: 
					is_stampable = data.get_custom_data("is_stampable")
					print("is stampal")
				
				if is_stampable:
					can_stamp = false
					spawn_stamp(stamped_point)
		
		if detect_ground_raycast.is_colliding():
				
			var body = detect_ground_raycast.get_collider()
			
			if detect_ground_raycast.get_collider() is WorldTileMap:
				
				var collision_point : Vector2 = detect_ground_raycast.get_collision_point()
				var stamped_point : Vector2i = body.get_snapped_position(collision_point)
				
				if stamped_point in locals_stamped: 
					remove_stamp(stamped_point)
					return
				
				var stamped_coords : Vector2i = body.get_coords(stamped_point)
				var data = body.get_cell_tile_data(stamped_coords)
				var is_stampable : bool = false
				
				if data: 
					is_stampable = data.get_custom_data("is_stampable")
					print("is stampal")
				
				if is_stampable:
					can_stamp = false
					spawn_stamp(stamped_point)

func remove_stamp(stamped_point : Vector2i) -> void:
	var old_stamp : StampInstance = locals_stamped[stamped_point]
	print(stamped_point)
	print(locals_stamped)
	if old_stamp.current_effect:
		if not old_stamp.current_effect is BreakEffect or not old_stamp.current_effect.is_effect_active:
			locals_stamped.erase(stamped_point)
	
	if is_instance_valid(old_stamp): old_stamp.remove_stamp(player)

func spawn_stamp(stamped_point : Vector2i) -> void:
	var stamp_instance : StampInstance = STAMP_SCENE.instantiate()
	stamp_instance.global_position = stamped_point
	stamp_instance.setup(stamp_color, stamped_point)
	locals_stamped[stamped_point] = stamp_instance
	player.stamp_container.add_child(stamp_instance)

func start_cooldown_time() -> void:
	current_cooldown_time = cooldown_time

func is_in_cooldown() -> bool:
	return current_cooldown_time > 0

func minus_cooldown_time(delta : float) -> void:
	if current_cooldown_time > 0:
		current_cooldown_time -= delta

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
	crosshair.play_squash()

func desactive_stamp_area() -> void:
	can_stamp = false
	start_cooldown_time()

func stamp_area_to_ground() -> void:
	player.stamping_sprite.position.x = crosshair.position.x
	player.stamping_sprite.position.y = 0.0

func stamp_area_to_wall() -> void:
	player.stamping_sprite.position.x = detect_wall_raycast.target_position.x
	player.stamping_sprite.position.y = detect_wall_raycast.target_position.y - 32.0
