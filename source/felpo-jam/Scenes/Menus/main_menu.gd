extends Control

@export var select_menu : Control

func _ready() -> void:
	Transition.play_fade_out()
	var tween : Tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 2.5).from(0.0)

func _on_main_menu_button_pressed(scene: Control) -> void:
	scene.on_visible()

func _on_back_pressed() -> void:
	select_menu.on_visible()
