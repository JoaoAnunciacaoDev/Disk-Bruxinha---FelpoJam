extends State
class_name DieState

var respawned : bool = false

func enter() -> void:
	player.die()
	player.jump_component.reset_jump_count()
	player.jump_component.stop_coyote_time()
	player.jump_component.stop_jump_buffer()
	player.stamp_component.stop_stamp_buffer()
	
	if not player.respawned.is_connected(_on_respawn):
		player.respawned.connect(_on_respawn)
	
	#SoundController.playSFX("die")

func update(delta : float) -> State:
	player.move_component.move(delta, 0.0)
	
	if respawned:
		respawned = false
		return state_machine.states["idle"]
	
	return null

func _on_respawn() -> void:
	respawned = true
