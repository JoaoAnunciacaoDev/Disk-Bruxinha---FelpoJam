extends StampEffect
class_name SpeedEffect

@export var speed_bonus : float = 0.5

func apply_effect(parent : Node2D, body : Node2D) -> void:
	if is_effect_active: return
	is_effect_active = true
	
	self.parent = parent
	body.move_component.apply_speed_effect(speed_bonus)

func timing_effect_duration(body : Node2D) -> void:
	if timer: timer.queue_free()
		
	timer = Timer.new()
	timer.wait_time = 1.0
	timer.one_shot = true
	timer.timeout.connect(func(): if not parent.is_body_in: 
		_on_timeout(body)
		timer.queue_free())
	
	if get_tree():
		get_tree().root.add_child(timer)
		timer.start()

func _on_timeout(body : Node2D) -> void:
	body.move_component.minus_speed_effect(speed_bonus)
	is_effect_active = false
