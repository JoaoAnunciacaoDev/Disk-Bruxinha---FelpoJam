extends StampEffect
class_name JumpEffect

@export var jump_bonus : float = 0.25

func apply_effect(parent : Node2D, body : Node2D) -> void:
	body.jump_component.apply_jump_effect(jump_bonus)

func timing_effect_duration(body : Node2D) -> void:
	var timer : Timer = Timer.new()
	timer.wait_time = 0.5
	timer.one_shot = true
	timer.timeout.connect(func(): body.jump_component.jump_multiplier -= jump_bonus)
	get_tree().root.add_child(timer)
	timer.start()
