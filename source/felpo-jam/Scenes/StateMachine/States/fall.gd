extends State
class_name FallState

func enter() -> void:
	if not player.is_stamping:
		player.anim_player.play("fall")

func handle_input(event : InputEvent) -> State:
	if event.is_action_pressed("jump"):
		if player.jump_component.has_coyote_time():
			return state_machine.states["jump"]
		
		player.jump_component.start_jump_buffer()
	
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
	
	if player.is_on_floor():
		player.play_squash()
		
		if player.jump_component.is_jump_buffering():
			return state_machine.states["jump"]
		
		if input_axis == 0:
			return state_machine.states["idle"]
		
		if input_axis != 0:
			return state_machine.states["walk"]
	
	return null
