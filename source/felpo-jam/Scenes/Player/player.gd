extends CharacterBody2D
class_name Player

signal respawned

@export_category("Flags")
@export var is_dead : bool
@export var is_stamping : bool
@export var has_package : bool
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
@export var anim_player : AnimationPlayer
@export var juice_player : AnimationPlayer
@export var state_machine : StateMachine
@export var world_tilemap : WorldTileMap

@export_category("Components Reference")
@export var move_component : MoveComponent
@export var jump_component : JumpComponent
@export var stamp_component : StampComponent

var last_save_position : Vector2

func _ready() -> void:
	last_save_position = global_position

func _process(delta: float) -> void:
	if is_dead: return
	
	state_machine.on_process(delta)

func _physics_process(delta: float) -> void:
	if is_dead: return
	
	state_machine.on_physics_process(delta)
	
	active_gravity(delta, jump_component.get_gravity())
	
	check_was_on_floor()
	
	move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	if is_dead: return
	
	state_machine.on_input(event)

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
		
		stamping_pivot.scale.x = int(input_axis)
		ground_pivot.scale.x = int(input_axis)
		stamp_component.detect_ground_raycast.scale.x = int(input_axis)
		stamp_component.detect_wall_raycast.scale.x = int(input_axis)

func active_remove_stamp() -> void:
	pass

func drop_package() -> void:
	pass

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
