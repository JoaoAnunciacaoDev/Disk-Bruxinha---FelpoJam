extends CharacterBody2D
class_name Player

signal respawned

const REMOVE_STAMP_SCENE : PackedScene = preload("res://Scenes/Stamp/RemoveStamp/removing_stamp_area.tscn")

@export_category("Flags")
@export var is_dead : bool
@export var is_stamping : bool
@export var has_carryable : bool
@export var is_removing_stamp : bool
@export var was_on_floor : bool
@export var has_blue_stamp : bool = true
@export var has_orange_stamp : bool
@export var has_red_stamp : bool

@export_category("Node's Reference")
@export var all_body_sprite : Node2D
@export var stamping_pivot : Node2D
@export var ground_pivot : Node2D
@export var stamping_sprite : Sprite2D
@export var superior_sprite : Sprite2D
@export var inferior_sprite : Sprite2D
@export var body_collision : CollisionShape2D
@export var interaction_area : Area2D
@export var carry_position_marker : Marker2D
@export var anim_player : AnimationPlayer
@export var juice_player : AnimationPlayer
@export var state_machine : StateMachine
@export var world_tilemap : WorldTileMap

@export_category("Components Reference")
@export var move_component : MoveComponent
@export var jump_component : JumpComponent
@export var stamp_component : StampComponent

@export_category("Throw Data")
@export var max_throw_force : float = 400.0
@export var throw_force : float = 0.0
@export var throw_rate : float = 500.0
@export var progress_bar : ProgressBar

var last_save_position : Vector2

var carry_position : Vector2
var carrying_object : CarryableObject

var facing : int = 1

func _ready() -> void:
	last_save_position = global_position

func _process(delta: float) -> void:
	if is_dead: return
	
	state_machine.on_process(delta)

func _physics_process(delta: float) -> void:
	if is_dead: return
	
	throw_force_update(delta)
		
	carry_position = carry_position_marker.global_position
	
	state_machine.on_physics_process(delta)
	
	active_gravity(delta, jump_component.get_gravity())
	
	check_was_on_floor()
	
	move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	if is_dead: return
	
	state_machine.on_input(event)
	
	if event.is_action_pressed("remove_stamp"): active_remove_stamp()

func active_gravity(delta : float, accel : float) -> void:
	if is_stamping:
		jump_component.cut_velocity_y()
	elif not is_on_floor() and velocity.y <= jump_component.max_fall_speed:
		velocity.y += accel * delta

func check_was_on_floor() -> void:
	if was_on_floor and not is_on_floor() and velocity.y >= 0:
		jump_component.start_coyote_time()
	was_on_floor = is_on_floor()

func flip_sprite(input_axis : float) -> void:
	if input_axis != 0 and not is_stamping:
		superior_sprite.flip_h = input_axis < 0
		inferior_sprite.flip_h = input_axis < 0
		facing = int(input_axis)
		#package_container.scale.x = int(input_axis)
		stamping_pivot.scale.x = int(input_axis)
		ground_pivot.scale.x = int(input_axis)
		stamp_component.detect_ground_raycast.scale.x = int(input_axis)
		stamp_component.detect_wall_raycast.scale.x = int(input_axis)

func active_remove_stamp() -> void:
	if is_removing_stamp: return
	is_removing_stamp = true
	
	var remove_stamp_instance : RemoveStamp = REMOVE_STAMP_SCENE.instantiate()
	remove_stamp_instance.global_position = global_position
	remove_stamp_instance.remove_finished.connect(_on_removed_stamp)
	get_tree().root.add_child(remove_stamp_instance)

func _on_removed_stamp(positions_list : Array[Vector2i]) -> void:
	is_removing_stamp = false
	
	for pos in positions_list:
		stamp_component.remove_stamp(pos)

func throw_force_update(delta : float) -> void:
	if Input.is_action_pressed("throw") and has_carryable:
		print(throw_force)
		throw_force = min(max_throw_force, throw_force + (delta * throw_rate))
		progress_bar.show()
		progress_bar.value = throw_force
	else:
		progress_bar.hide()
		progress_bar.value = 0.0

func handle_pickup_object() -> void:
	if carrying_object:
		if Input.is_action_just_released("throw"):
		
			carrying_object.state = carrying_object.States.Dropped
			carrying_object.throw_velocity = Vector2(throw_force, -throw_force)
			print("Thoew velo ", throw_force)
			
			if velocity == Vector2.ZERO:
				carrying_object.velocity = carrying_object.throw_velocity * Vector2(facing, 1)
			else:
				carrying_object.velocity = (velocity * 1.25) + carrying_object.throw_velocity * Vector2(facing, 1)
			
			throw_force = 0.0
			
			carrying_object.carrier = null
			carrying_object = null
			has_carryable = false
	
	else:
		
		var bodies : Array[Node2D] = interaction_area.get_overlapping_bodies()
		if bodies.size() > 0:
			for body in bodies:
				if body is CarryableObject and (body.state == body.States.Pickupable):
					if Input.is_action_just_pressed("catch"):
						carrying_object = body
						body.carrier = self
						body.global_position = carry_position
						body.state = body.States.Carry
						has_carryable = true
					else:
						body.show_interaction_action()

func drop_carried_object() -> void:
	if carrying_object:
		carrying_object.velocity = Vector2.ZERO
		carrying_object.state = carrying_object.States.Dropped
		carrying_object.carrier = null
		carrying_object = null

func die() -> void:
	body_collision.disabled = true
	anim_player.play("die")
	
	var tween : Tween = create_tween().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "global_position", last_save_position, 5.0)
	tween.finished.connect(func(): 
		is_dead = false
		body_collision.disabled = false
		respawned.emit()
		)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "stamp_ground" or anim_name == "stamp_wall":
		stamp_component._on_stamp_finished.emit()

func _on_juice_animation_animation_finished(anim_name: StringName) -> void:
	if anim_name == "squash" and state_machine.current_state.name == "jump":
		juice_player.play("stretch")
