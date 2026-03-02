extends Node

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func change_scene_to(scene : String) -> void:
	Transition.play_fade_in()
	await Transition.transition_over
	get_tree().change_scene_to_file(scene)
	await get_tree().process_frame
	Transition.play_fade_out()
