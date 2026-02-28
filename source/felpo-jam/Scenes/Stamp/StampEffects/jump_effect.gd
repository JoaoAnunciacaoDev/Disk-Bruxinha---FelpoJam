extends StampEffect
class_name JumpEffect

@export var jump_bonus : float = 0.25

func apply_effect(parent : Node2D, body : Node2D) -> void:
	if is_effect_active: return
	is_effect_active = true
	
	self.parent = parent
	body.jump_component.apply_jump_effect(jump_bonus)

func timing_effect_duration(body : Node2D) -> void:
	if timer: timer.queue_free()
	
	timer = Timer.new()
	timer.wait_time = 1.0
	timer.one_shot = true
	timer.timeout.connect(func(): if not parent.is_body_in: 
		_on_timeout(body)
		timer.queue_free())
	
	get_tree().root.add_child(timer)
	timer.start()

func _on_timeout(body : Node2D) -> void:
	body.jump_component.minus_jump_effect(jump_bonus)
	is_effect_active = false
