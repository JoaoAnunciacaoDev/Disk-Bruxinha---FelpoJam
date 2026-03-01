extends Node2D
class_name GhostSpawner

@export var ghostScene : PackedScene = preload("res://Scenes/GhostSpawner/ghost_sprite.tscn")
@export var sprite : Sprite2D
@export var color : Dictionary[String, Color] = {"Carimbo Azul": Color(0.0, 0.0, 0.769, 0.769),
												"Carimbo Laranja": Color(0.592, 0.243, 0.0, 0.769)}

@export var timer : Timer

var selected_color : Color

func startSpawn(color_name : String) -> void:
	selected_color = color[color_name]
	timer.start()

func stopSpawn() -> void:
	timer.stop()

func _on_timer_timeout() -> void:
	var instance = ghostScene.instantiate()
	get_tree().current_scene.add_child(instance)
	instance.global_position = sprite.global_position
	instance.rotation = sprite.rotation
	instance.texture = sprite.texture
	instance.self_modulate = selected_color
	instance.scale = sprite.scale
	instance.flip_h = sprite.flip_h
	instance.z_index = 0
