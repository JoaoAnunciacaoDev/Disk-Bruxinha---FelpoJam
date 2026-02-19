extends State
class_name JumpState

func enter() -> void:
	#SfxManager.play_sfx("jump")
	player.jump_component.jump()
	player.jump_component.stop_coyote_time()
	player.jump_component.stop_jump_buffer()
	
	if not player.is_stamping:
		player.anim_player.play("jump")

func handle_input(event : InputEvent) -> State:
	if event.is_action_released("jump"):
		player.jump_component.cut_velocity_y()
		return state_machine.states["fall"]
	
	if event.is_action_pressed("blue_stamp"):
		player.stamp_component.start_stamp_buffer("blue_stamp")
	elif event.is_action_pressed("orange_stamp"):
		player.stamp_component.start_stamp_buffer("orange_stamp")
	elif event.is_action_pressed("red_stamp"):
		player.stamp_component.start_stamp_buffer("red_stamp")
	
	return null

func physics_update(delta: float) -> State:
	var input_axis : float = Input.get_axis("left", "right")
	player.move_component.move(delta, input_axis)
	player.flip_sprite(input_axis)
	
	if player.stamp_component.is_stamp_buffering() and not player.is_stamping:
		return state_machine.states["stamp"]
		
	if player.velocity.y > 0:
		return state_machine.states["fall"]
	
	return null
