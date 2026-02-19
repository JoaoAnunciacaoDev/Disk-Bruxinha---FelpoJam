extends Node2D
class_name StampInstance

@export var stamp_sprites : Dictionary[String, Texture2D]
@export var stamp_effects : Dictionary[String, PackedScene]
@export var sprite : Sprite2D
@export var current_effect : StampEffect

func setup(stamp_name : String) -> void:
	sprite.texture = stamp_sprites[stamp_name]
	current_effect = stamp_effects[stamp_name].instantiate()
	add_child(current_effect)

func _on_effect_area_body_entered(body: Node2D) -> void:
	if current_effect:
		current_effect.apply_effect(self, body)

func _on_effect_area_body_exited(body: Node2D) -> void:
	if current_effect:
		current_effect.timing_effect_duration(body)
