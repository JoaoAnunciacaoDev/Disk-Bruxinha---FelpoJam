extends StampEffect
class_name JumpEffect

@export var jump_bonus : float = 0.25
@export var effect_duration : float = 1.0
var buff_timer : Timer
var affected_body : Node2D

func _ready() -> void:
	buff_timer = Timer.new()
	buff_timer.wait_time = max(effect_duration, 0.001)
	buff_timer.one_shot = true
	buff_timer.timeout.connect(_on_timer_timeout)
	add_child(buff_timer)

func apply_effect(parent_node : Node2D, body : Node2D) -> void:
	self.parent = parent_node

	if is_effect_active:
		if body == affected_body and not buff_timer.is_stopped():
			buff_timer.stop()
		return

	self.affected_body = body
	is_effect_active = true

	body.jump_component.apply_jump_effect(jump_bonus)

func timing_effect_duration(body : Node2D) -> void:
	if not is_effect_active or body != affected_body:
		return

	if effect_duration <= 0.0:
		remove_effect()
	elif buff_timer and buff_timer.is_inside_tree():
		buff_timer.start(effect_duration)

func _on_timer_timeout() -> void:
	remove_effect()

func remove_effect() -> void:
	if not is_effect_active:
		return

	is_effect_active = false
	if buff_timer and not buff_timer.is_stopped():
		buff_timer.stop()
	if is_instance_valid(affected_body):
		affected_body.jump_component.minus_jump_effect(jump_bonus)
	affected_body = null
