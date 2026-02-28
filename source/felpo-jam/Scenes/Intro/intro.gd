extends CanvasLayer

const MAIN_MENU = preload("res://Scenes/Menus/main_menu.tscn")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	SceneChanger.change_scene_to(MAIN_MENU)
