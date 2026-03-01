extends CanvasLayer

@export var main_menu : PackedScene

@export var anim_player : AnimationPlayer

func _ready() -> void:
	SongManager.start_track_with_fade_in("default_song")
	anim_player.play("scroll")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	AchievementsManager.unlock("finish_game")
	SceneChanger.change_scene_to(ScenesReference.scenes_list["main_menu"])
