extends State
class_name FallState

func enter() -> void:
	player.anim.play("fall")

func handle_input(event : InputEvent) -> State:
	if event.is_action_pressed("jump"):
		if player.jump_component.has_coyote_time():
			return state_machine.states["jump"]
		
		player.start_jump_buffer()
	
	if event.is_action_pressed("blue_stamp") or  event.is_action_pressed("orange_stamp") or \
	event.is_action_pressed("red_stamp"):
		player.stamp_component.start_stamp_buffer()
	
	return null

func physics_update(delta: float) -> State:
	var input_axis : float = Input.get_axis("left", "right")
	player.move(delta, input_axis)
	player.flip_sprite(input_axis)
	
	if player.stamp_component.is_stamp_buffering():
		return state_machine.states["stamp"]
	
	if player.is_on_floor():
		player.play_squash_n_stretch()
		
		if player.is_jump_buffering():
			return state_machine.states["jump"]
		
		if input_axis == 0:
			return state_machine.states["idle"]
		
		if input_axis != 0:
			return state_machine.states["walk"]
	
	return null
