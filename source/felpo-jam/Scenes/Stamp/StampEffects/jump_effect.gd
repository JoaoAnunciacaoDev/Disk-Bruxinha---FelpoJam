extends StampEffect
class_name JumpEffect

@export var jump_bonus : float = 0.25
var buff_timer : Timer
var affected_body : Node2D

func _ready() -> void:
	buff_timer = Timer.new()
	buff_timer.wait_time = 1.0
	buff_timer.one_shot = true
	buff_timer.timeout.connect(_on_timer_timeout)
	add_child(buff_timer)

func apply_effect(parent_node : Node2D, body : Node2D) -> void:
	self.parent = parent_node
	self.affected_body = body
	
	if not buff_timer.is_stopped():
		buff_timer.stop()
		
	if is_effect_active: return
	is_effect_active = true
	
	body.jump_component.apply_jump_effect(jump_bonus)

func timing_effect_duration(body : Node2D) -> void:
	if is_effect_active:
		buff_timer.start()

func _on_timer_timeout() -> void:
	if is_instance_valid(affected_body):
		affected_body.jump_component.minus_jump_effect(jump_bonus)
	is_effect_active = false
