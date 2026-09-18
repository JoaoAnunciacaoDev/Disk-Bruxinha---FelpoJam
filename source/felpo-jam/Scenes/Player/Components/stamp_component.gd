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
	if not can_stamp: return

	var target := get_stamp_target()
	if target.is_empty(): return

	var stamped_point : Vector2i = target["position"]
	if stamped_point in locals_stamped:
		remove_stamp(stamped_point)
		return

	var tilemap : WorldTileMap = target["tilemap"]
	var data := tilemap.get_cell_tile_data(target["coords"])
	if data and data.get_custom_data("is_stampable"):
		can_stamp = false
		spawn_stamp(stamped_point)

func get_stamp_target() -> Dictionary:
	var raycast : RayCast2D
	var surface := ""
	var is_ground_target_valid := (
		detect_ground_raycast.is_colliding()
		and detect_ground_raycast.get_collider() is WorldTileMap
	)
	var is_wall_target_valid := (
		detect_wall_raycast.is_colliding()
		and detect_wall_raycast.get_collider() is WorldTileMap
	)

	# Segurar para baixo permite escolher o chão mesmo quando o raycast da
	# parede também está colidindo. Sem esse comando, a parede mantém prioridade.
	if Input.is_action_pressed("down") and is_ground_target_valid:
		raycast = detect_ground_raycast
		surface = "ground"
	elif is_wall_target_valid:
		raycast = detect_wall_raycast
		surface = "wall"
	elif is_ground_target_valid:
		raycast = detect_ground_raycast
		surface = "ground"
	else:
		return {}

	var tilemap := raycast.get_collider() as WorldTileMap
	var coords := tilemap.get_collision_coords(
		raycast.get_collision_point(), raycast.get_collision_normal()
	)
	var top_left := Vector2i(tilemap.get_tile_global_position(coords).round())
	var collision_normal := raycast.get_collision_normal().normalized()
	var half_tile_size := Vector2(tilemap.tile_set.tile_size) * 0.5
	var surface_depth := (
		absf(collision_normal.x) * half_tile_size.x
		+ absf(collision_normal.y) * half_tile_size.y
	)
	var visual_position := raycast.get_collision_point() - collision_normal * surface_depth

	return {
		"tilemap": tilemap,
		"coords": coords,
		"position": top_left,
		"center": tilemap.get_tile_global_center(coords),
		"visual_position": visual_position,
		"surface": surface,
	}

func remove_stamp(stamped_point : Vector2i) -> void:
	var old_stamp : StampInstance = locals_stamped[stamped_point]
	print(stamped_point)
	print(locals_stamped)
	if old_stamp.current_effect:
		if not old_stamp.current_effect is BreakEffect or not old_stamp.current_effect.is_effect_active:
			locals_stamped.erase(stamped_point)
	
	if is_instance_valid(old_stamp): old_stamp.remove_stamp()

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

func start_stamp_buffer(new_stamp_color : String) -> bool:
	if not is_stamp_unlocked(new_stamp_color):
		return false

	stamp_color = new_stamp_color
	current_stamp_time = stamp_time_buffer
	return true

func is_stamp_unlocked(stamp_name : String) -> bool:
	match stamp_name:
		"blue_stamp":
			return player.has_blue_stamp
		"orange_stamp":
			return player.has_orange_stamp
		"red_stamp":
			return player.has_red_stamp
		_:
			return false

func is_stamp_buffering() -> bool:
	return current_stamp_time > 0

func minus_stamp_time(delta : float) -> void:
	if current_stamp_time > 0:
		current_stamp_time -= delta

func stop_stamp_buffer() -> void:
	current_stamp_time = 0

func facing_wall() -> bool:
	var target := get_stamp_target()
	return not target.is_empty() and target["surface"] == "wall"

func active_stamp_area() -> void:
	can_stamp = true
	crosshair.play_squash()

func desactive_stamp_area() -> void:
	can_stamp = false
	start_cooldown_time()

func stamp_area_to_ground() -> void:
	var target := get_stamp_target()
	if not target.is_empty():
		player.stamping_sprite.position.x = player.to_local(target["center"]).x
	player.stamping_sprite.position.y = 0.0

func stamp_area_to_wall() -> void:
	player.stamping_sprite.position.x = detect_wall_raycast.target_position.x
	player.stamping_sprite.position.y = detect_wall_raycast.target_position.y - 32.0
