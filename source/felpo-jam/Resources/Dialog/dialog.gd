extends Resource
class_name Dialog

@export var dialogs : Dictionary = {}

func load_from_json(file_path : String) -> void:
	var data : String = FileAccess.get_file_as_string(file_path)
	var parsed_data : Dictionary = JSON.parse_string(data)
	
	if parsed_data:
		dialogs = parsed_data
	else:
		print("Falhou no parser: ", parsed_data)

func get_npc_dialog(npc_id : String) -> Array:
	if npc_id in dialogs:
		return dialogs[npc_id]["tree"]
	
	return []
