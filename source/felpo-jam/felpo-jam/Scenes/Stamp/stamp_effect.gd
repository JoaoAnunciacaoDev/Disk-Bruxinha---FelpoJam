extends Node
class_name StampEffect

var parent : StampInstance
var timer : Timer
var is_effect_active : bool = false

func apply_effect(parent : Node2D, body : Node2D) -> void:
	pass

func timing_effect_duration(body : Node2D) -> void:
	pass

func _on_timeout(body : Node2D) -> void:
	pass
