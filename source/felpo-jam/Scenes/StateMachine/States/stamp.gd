extends State
class_name StampState

func enter() -> void:
	player.is_stamping = true
	player.stamp_component.stop_stamp_buffer()
	
	if player.stamp_component.facing_wall():
		print("parede detectada")
		player.anim_player.play("stamp_wall")
	else:
		print("chão pow")
		player.anim_player.play("stamp_ground")
	
	if not player.stamp_component._on_stamp_finished.is_connected(_on_stamp_finished):
		player.stamp_component._on_stamp_finished.connect(_on_stamp_finished)

func handle_input(event : InputEvent) -> State:
	if event.is_action_pressed("jump"):
		player.jump_component.start_jump_buffer()
	
	if event.is_action_pressed("blue_stamp"):
		player.stamp_component.start_stamp_buffer("blue_stamp")
	elif event.is_action_pressed("orange_stamp"):
		player.stamp_component.start_stamp_buffer("orange_stamp")
	elif event.is_action_pressed("red_stamp"):
		player.stamp_component.start_stamp_buffer("red_stamp")
	
	return null

func physics_update(delta : float) -> State:
	var input_axis : float = Input.get_axis("left", "right")
	player.move_component.move(delta, input_axis)
	
	if player.velocity.y > 0:
		return state_machine.states["fall"]
	
	if not player.is_stamping:
		if player.jump_component.can_jump() and player.jump_component.is_jump_buffering():
			return state_machine.states["jump"]
		
		if input_axis != 0 and player.is_on_floor():
			return state_machine.states["walk"]
		
		if input_axis == 0 and player.is_on_floor():
			return state_machine.states["idle"]
	
	return null

func _on_stamp_finished() -> void:
	print("A animação acabou")
	player.is_stamping = false
	
