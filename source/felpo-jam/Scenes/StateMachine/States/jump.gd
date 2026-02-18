extends State
class_name JumpState

func enter() -> void:
	#SfxManager.play_sfx("jump")
	player.jump_component.jump()
	player.jump_component.stop_coyote_timer()
	
	if not player.is_stamping:
		player.anim_player.play("jump")

func handle_input(event : InputEvent) -> State:
	if event.is_action_released("jump"):
		player.jump_component.cut_velocity_y()
		return state_machine.states["fall"]
	
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
		
	if player.velocity.y > 0:
		return state_machine.states["fall"]
	
	return null
