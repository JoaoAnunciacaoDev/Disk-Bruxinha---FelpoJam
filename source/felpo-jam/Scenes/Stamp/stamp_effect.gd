extends Node
class_name StampEffect

var parent : StampInstance
var timer : Timer
var is_effect_active : bool = false

func apply_effect(_parent : Node2D, _body : Node2D) -> void:
	pass

func timing_effect_duration(_body : Node2D) -> void:
	pass

func remove_effect() -> void:
	is_effect_active = false
