extends Node2D

const DEBUG_SCENE = preload("uid://cbgpvwf4bndks")

@export var tutorial_end_node : CanvasLayer
@export var text_2 : Label

func _on_npc_detect_body_entered(body: Node2D) -> void:
	body.can_move = false
	await get_tree().create_timer(3.0).timeout
	tutorial_end_node.show()
	await get_tree().create_timer(2.5).timeout
	text_2.show()
	await get_tree().create_timer(1.5).timeout
	
	SceneChanger.change_scene_to(DEBUG_SCENE)
