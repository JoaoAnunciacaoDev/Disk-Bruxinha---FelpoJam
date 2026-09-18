extends Node

var is_changing_scene : bool = false

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func preload_scene(scene : String) -> Error:
	if ResourceLoader.has_cached(scene):
		return OK

	var load_status := ResourceLoader.load_threaded_get_status(scene)
	if load_status == ResourceLoader.THREAD_LOAD_IN_PROGRESS \
	or load_status == ResourceLoader.THREAD_LOAD_LOADED:
		return OK

	return ResourceLoader.load_threaded_request(scene)

func change_scene_to(scene : String) -> void:
	if is_changing_scene:
		return
	is_changing_scene = true

	var request_error := preload_scene(scene)
	Transition.play_fade_in()
	await Transition.transition_over

	var packed_scene : PackedScene
	if ResourceLoader.has_cached(scene):
		packed_scene = ResourceLoader.load(scene) as PackedScene
	elif request_error == OK:
		var load_status := ResourceLoader.load_threaded_get_status(scene)
		while load_status == ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			await get_tree().process_frame
			load_status = ResourceLoader.load_threaded_get_status(scene)

		if load_status == ResourceLoader.THREAD_LOAD_LOADED:
			packed_scene = ResourceLoader.load_threaded_get(scene) as PackedScene
		else:
			push_warning("Falha ao carregar a cena em segundo plano: %s" % scene)
	else:
		push_warning("Não foi possível iniciar o carregamento da cena: %s" % scene)

	if packed_scene:
		get_tree().change_scene_to_packed(packed_scene)
	else:
		get_tree().change_scene_to_file(scene)

	await get_tree().process_frame
	Transition.play_fade_out()
	await Transition.transition_over
	is_changing_scene = false
