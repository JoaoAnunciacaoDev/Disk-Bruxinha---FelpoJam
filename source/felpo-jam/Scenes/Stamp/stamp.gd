extends Node2D
class_name StampInstance

@export var stamp_sprites : Dictionary[String, Texture2D]
@export var stamp_effects : Dictionary[String, PackedScene]
@export var sprite : Sprite2D
@export var current_effect : StampEffect

var is_body_in : bool = false
var stamp_pos : Vector2i
var can_detect_in : bool = true
var can_detect_out : bool = true

func setup(stamp_name : String, stamp_point : Vector2i) -> void:
	stamp_pos = stamp_point
	sprite.texture = stamp_sprites[stamp_name]
	current_effect = stamp_effects[stamp_name].instantiate()
	add_child(current_effect)

func _on_effect_area_body_entered(body: Node2D) -> void:
	if not can_detect_in: return
	
	is_body_in = true
	if current_effect:
		current_effect.apply_effect(self, body)

func _on_effect_area_body_exited(body: Node2D) -> void:
	if not can_detect_out: return
	
	is_body_in = false
	if current_effect:
		current_effect.timing_effect_duration(body)

func remove_stamp() -> void:
	if current_effect:
		if current_effect is BreakEffect:
			if current_effect.is_effect_active:
				return
		
		can_detect_in = false
		can_detect_out = false
		
		if current_effect.is_effect_active:
			current_effect._on_timer_timeout()
			if current_effect.buff_timer:
				current_effect.buff_timer.stop()
		
		call_deferred("queue_free")
