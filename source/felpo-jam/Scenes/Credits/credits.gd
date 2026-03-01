extends CanvasLayer

const MAIN_MENU = preload("res://Scenes/Menus/main_menu.tscn")

@export var anim_player : AnimationPlayer

func _ready() -> void:
	anim_player.play("scroll")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	AchievementsManager.unlock("finish_game")
	SceneChanger.change_scene_to(MAIN_MENU)
