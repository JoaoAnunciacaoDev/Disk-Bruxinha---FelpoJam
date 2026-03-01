extends Node2D

const CREDITS = preload("res://Scenes/Credits/Credits.tscn")

@export var npc_final : Node2D
@export var npc_final_area : Area2D
@export var end_node : CanvasLayer
@export var text_2 : Label

func _ready() -> void:
	SongManager.transition_to_track("default_song")

func _on_npc_detect_body_entered(body: Node2D) -> void:
	body.can_move = false
	if not body.died_one_time: AchievementsManager.unlock("no_deaths")
	SongManager.transition_to_track("game_over")
	
	await get_tree().create_timer(3.0).timeout
	end_node.show()
	await get_tree().create_timer(2.5).timeout
	text_2.show()
	await get_tree().create_timer(1.5).timeout
	
	SceneChanger.change_scene_to(CREDITS)

func _on_gnome_house_3_delivery_complete() -> void:
	npc_final.show()
	npc_final_area.monitorable = true
	npc_final_area.monitoring = true
