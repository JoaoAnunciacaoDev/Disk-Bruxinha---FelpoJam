extends State
class_name IdleState

func enter() -> void:
	player.anim_player.play("idle")
	player.reset_jump_count()

func handle_input(event: InputEvent) -> State:
	if event.is_action_pressed("jump"):
		player.start_jump_buffer()
	
	if event.is_action_pressed("blue_stamp") or  event.is_action_pressed("orange_stamp") or \
	event.is_action_pressed("red_stamp"):
		player.stamp_component.start_stamp_buffer()
	
	return null

func physics_update(delta : float) -> State:
	var input_axis : float = Input.get_axis("left", "right")
	player.move(delta, 0.0)
	
	if player.stamp_component.is_stamp_buffering():
		return state_machine.states["stamp"]
	
	if player.jump_component.can_jump() and player.jump_component.is_jump_buffering():
		player.jump_component.stop_jump_buffer()
		player.jump_component.stop_coyote_time()
		return state_machine.states["jump"]
	
	if input_axis != 0 and player.is_on_floor():
		return state_machine.states["walk"]
	
	if player.velocity.y > 0:
		return state_machine.states["fall"]
	
	return null
