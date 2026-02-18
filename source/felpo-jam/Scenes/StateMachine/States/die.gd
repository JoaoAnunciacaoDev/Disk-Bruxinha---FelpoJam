extends State
class_name DieState

func enter() -> void:
	player.anim_player.play("die")
	player.jump_component.reset_jump_count()
	player.jump_component.stop_coyote_time()
	player.jump_component.stop_jump_buffer()
	#SoundController.playSFX("die")

func update(delta : float) -> State:
	player.move_component.move(delta, 0.0)
	
	return null
