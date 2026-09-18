extends Node2D

@export var pause_menu : CanvasLayer
@export var tutorial_end_node : CanvasLayer
@export var text_2 : Label

var finished : bool = false

func _ready() -> void:
	SceneChanger.preload_scene(ScenesReference.scenes_list["game"])

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause") and not finished:
		pause_menu.on_visible()

func _on_npc_detect_body_entered(body: Node2D) -> void:
	body.can_move = false
	finished = true
	SongManager.transition_to_track("game_over")
	
	await get_tree().create_timer(3.0).timeout
	tutorial_end_node.show()
	await get_tree().create_timer(2.5).timeout
	text_2.show()
	await get_tree().create_timer(1.5).timeout
	
	SceneChanger.change_scene_to(ScenesReference.scenes_list["game"])
