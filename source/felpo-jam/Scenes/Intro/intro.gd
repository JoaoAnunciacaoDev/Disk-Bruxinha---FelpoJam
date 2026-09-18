extends CanvasLayer

func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	SceneChanger.change_scene_to(ScenesReference.scenes_list["main_menu"])
