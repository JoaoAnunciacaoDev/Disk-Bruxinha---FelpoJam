extends CharacterBody2D
class_name Player

@export_category("Flags")
@export var is_dead : bool
@export var is_stamping : bool
@export var has_package : bool
@export var is_removing_stamp : bool
@export var is_vision_active : bool
@export var was_on_floor : bool

@export_category("Node's Reference")
@export var superior_sprite : Sprite2D
@export var inferior_sprite : Sprite2D
@export var anim_player : AnimationPlayer
@export var state_machine : StateMachine
@export var detect_wall_raycast : RayCast2D

@export_category("Components Reference")
@export var move_component : MoveComponent
@export var jump_component : JumpComponent
@export var stamp_component : StampComponent

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if is_dead: return
	
	state_machine.on_process(delta)

func _physics_process(delta: float) -> void:
	if is_dead: return
	
	state_machine.on_physics_process(delta)
	
	active_gravity(delta, jump_component.gravity)
	
	check_was_on_floor()
	
	move_and_slide()
	
	$Label.text = state_machine.current_state.name + "\n" + str(velocity)

func _unhandled_input(event: InputEvent) -> void:
	if is_dead: return
	
	state_machine.on_input(event)

func active_gravity(delta : float, accel : float) -> void:
	if not is_on_floor():
		velocity.y += accel * delta

func check_was_on_floor() -> void:
	if was_on_floor and not is_on_floor() and velocity.y >= 0:
		jump_component.start_coyote_time()
	was_on_floor = is_on_floor()

func flip_sprite(input_axis : float) -> void:
	if input_axis != 0 and not is_stamping:
		superior_sprite.flip_h = input_axis < 0
		inferior_sprite.flip_h = input_axis < 0
		detect_wall_raycast.scale.x = int(input_axis)

func play_squash() -> void:
	pass

func play_stretch() -> void:
	pass

func active_vision() -> void:
	pass

func active_remove_stamp() -> void:
	pass

func take_damage() -> void:
	pass

func drop_package() -> void:
	pass

func die() -> void:
	pass

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "stamp_ground" or anim_name == "stamp_wall":
		stamp_component._on_stamp_finished.emit()
