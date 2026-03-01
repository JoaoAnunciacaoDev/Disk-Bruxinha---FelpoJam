extends CanvasLayer

const MAIN_MENU = preload("uid://cb1te3h3qphk4")
const CONFIRM_STAMP = preload("res://Assets/SeloConfirmação.png")

@export var vbox : VBoxContainer
@export var back_button : TextureButton
@export var options_menu : Control

func _ready() -> void:
	hide()

func on_visible() -> void:
	if visible: 
		hide()
		return
	
	get_tree().paused = true
	for child in vbox.get_children():
		if child is TextureButton:
			child.set_texture_focused(CONFIRM_STAMP)
	back_button.grab_focus()
	show()

func _on_back_pressed() -> void:
	get_tree().paused = false
	hide()

func _on_options_pressed() -> void:
	vbox.hide()
	options_menu.on_visible()

func _on_menu_pressed() -> void:
	get_tree().paused = false
	vbox.hide()
	SceneChanger.change_scene_to(ScenesReference.scenes_list["main_menu"])

func _on_options_back_pressed() -> void:
	back_button.grab_focus()
	vbox.show()
