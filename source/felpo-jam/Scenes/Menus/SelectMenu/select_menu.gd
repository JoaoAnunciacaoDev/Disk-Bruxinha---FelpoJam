extends Control

const CONFIRM_STAMP = preload("res://Assets/SeloConfirmação.png")

signal button_pressed(scene : Control)

@export var options : Control
@export var achievements : Control
@export var credits : Control

@export var vbox : VBoxContainer
@export var play_button : TextureButton

var play_request_pending : bool = false

func _ready() -> void:
	on_visible()

func on_visible() -> void:
	for child in vbox.get_children():
		if child is TextureButton:
			child.set_texture_focused(CONFIRM_STAMP)
	play_button.grab_focus()
	show()

func _on_play_button_pressed() -> void:
	if play_request_pending:
		return

	play_request_pending = true
	_set_menu_buttons_disabled(true)
	SfxManager.play_sfx("button_pressed")

	# Se o menu ainda estiver abrindo após a introdução, preserva o clique e
	# inicia a próxima transição assim que a atual realmente terminar.
	if SceneChanger.is_changing_scene:
		await SceneChanger.scene_change_finished

	if not is_inside_tree():
		return

	hide()
	SceneChanger.change_scene_to(ScenesReference.scenes_list["world_tutorial"])

func _set_menu_buttons_disabled(is_disabled : bool) -> void:
	for child in vbox.get_children():
		if child is BaseButton:
			child.disabled = is_disabled

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
