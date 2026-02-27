extends Control

const WORLD_TUTORIAL : PackedScene = preload("res://Scenes/Game/Rooms/Tutorial/world_tutorial.tscn")

signal button_pressed(scene : Control)

@export var options : Control
@export var achievements : Control
@export var credits : Control

func _on_play_button_pressed() -> void:
	SfxManager.play_sfx("button_pressed")
	hide()
	SceneChanger.change_scene_to(WORLD_TUTORIAL)

func _on_options_button_pressed() -> void:
	SfxManager.play_sfx("button_pressed")
	hide()
	emit_signal("button_pressed", options)

func _on_achieviments_button_pressed() -> void:
	SfxManager.play_sfx("button_pressed")
	hide()
	emit_signal("button_pressed", achievements)

func _on_credits_button_pressed() -> void:
	SfxManager.play_sfx("button_pressed")
	hide()
	emit_signal("button_pressed", credits)

func _on_quit_button_pressed() -> void:
	SfxManager.play_sfx("button_pressed")
	get_tree().quit()
