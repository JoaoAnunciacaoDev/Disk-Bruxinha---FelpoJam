extends StampEffect
class_name SpeedEffect

@export var speed_bonus : float = 0.5

func apply_effect(parent : Node2D, body : Node2D) -> void:
	body.move_component.apply_speed_effect(speed_bonus)

func timing_effect_duration(body : Node2D) -> void:
	var timer : Timer = Timer.new()
	timer.wait_time = 1.0
	timer.one_shot = true
	timer.timeout.connect(func(): body.move_component.speed_multiplier -= speed_bonus)
	get_tree().root.add_child(timer)
	timer.start()
