extends Node

signal achievement_unlocked(achievement_data: Achievement)

const SAVE_FILE_PATH = "user://achievements.json"

@export var achievementsFiles : Array[Achievement]

var all_achievements: Dictionary = {}
var unlocked_ids: Array[String] = []

func _ready():
	_load_all_achievement_resources()
	load_progress()

func unlock(id: String):
	if not all_achievements.has(id) or is_unlocked(id):
		return

	print("Conquista Desbloqueada: ", id)
	unlocked_ids.append(id)
	achievement_unlocked.emit(all_achievements[id])
	
	save_progress()

func is_unlocked(id: String) -> bool:
	return id in unlocked_ids

func _load_all_achievement_resources():
	for achievement in achievementsFiles:
		if achievement:
			all_achievements[achievement.id] = achievement

func save_progress():
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	if not file:
		printerr("Falha ao abrir/criar o arquivo de save em: ", SAVE_FILE_PATH)
		return
	
	if unlocked_ids.size() == all_achievements.size() - 1: unlock("3")
	
	var json_string = JSON.stringify(unlocked_ids)
	file.store_string(json_string)
	file.close()

func load_progress():
	if not FileAccess.file_exists(SAVE_FILE_PATH):
		return
		
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
	if not file:
		printerr("Falha ao ler o arquivo de save em: ", SAVE_FILE_PATH)
		return
	
	var content = file.get_as_text()
	file.close()
	
	if content.is_empty():
		return
	
	var parse_result = JSON.parse_string(content)
	if parse_result and typeof(parse_result) == TYPE_ARRAY:
		var loaded_ids: Array[String] = []
		for item in parse_result:
			if typeof(item) == TYPE_STRING:
				loaded_ids.append(item)
			else:
				printerr("Item inválido encontrado no arquivo de save: ", item)
			
		unlocked_ids = loaded_ids
	else:
		printerr("Arquivo de save corrompido ou em formato inválido.")
