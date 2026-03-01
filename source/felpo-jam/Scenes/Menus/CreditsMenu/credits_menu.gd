extends Control

signal back_pressed

const CONFIRM_STAMP = preload("res://Assets/SeloConfirmação.png")

@export var back_button : TextureButton

func on_visible() -> void:
	back_button.set_texture_focused(CONFIRM_STAMP)
	back_button.grab_focus()
	show()

func _on_back_pressed() -> void:
	back_pressed.emit()
	hide()
	SfxManager.play_sfx("button_pressed")
