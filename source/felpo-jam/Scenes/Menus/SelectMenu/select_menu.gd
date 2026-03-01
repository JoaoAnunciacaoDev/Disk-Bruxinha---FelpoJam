extends Control

const CONFIRM_STAMP = preload("res://Assets/SeloConfirmação.png")

signal button_pressed(scene : Control)

@export var options : Control
@export var achievements : Control
@export var credits : Control

@export var vbox : VBoxContainer
@export var play_button : TextureButton

func _ready() -> void:
	on_visible()

func on_visible() -> void:
	for child in vbox.get_children():
		if child is TextureButton:
			child.set_texture_focused(CONFIRM_STAMP)
	play_button.grab_focus()
	show()

func _on_play_button_pressed() -> void:
	SfxManager.play_sfx("button_pressed")
	hide()
	SceneChanger.change_scene_to(ScenesReference.scenes_list["world_tutorial"])

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
