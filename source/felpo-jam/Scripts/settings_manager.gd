extends Node

const SETTINGS_PATH = "user://settings.json"
var settings: Dictionary = {}

const DEFAULTS = {
	"master_volume": 0.0,
	"song_volume": -30.0,
	"sfx_volume": -30.0,
	"v_sync": DisplayServer.VSYNC_ADAPTIVE,
	"screen": DisplayServer.WINDOW_MODE_FULLSCREEN
}

func _ready():
	load_settings()

func load_settings():
	if not FileAccess.file_exists(SETTINGS_PATH):
		save_settings()
		return

	var file = FileAccess.open(SETTINGS_PATH, FileAccess.READ)
	var data = JSON.parse_string(file.get_as_text())
	if data:
		settings = data
	else:
		settings = DEFAULTS.duplicate()
		
	apply_all_settings()

func save_settings():
	var file = FileAccess.open(SETTINGS_PATH, FileAccess.WRITE)
	file.store_string(JSON.stringify(settings, "\t"))
	print("Configurações salvas.")

func apply_all_settings():
	DisplayServer.window_set_vsync_mode(settings.get("v_sync", DEFAULTS.v_sync))
	DisplayServer.window_set_mode(settings.get("screen", DEFAULTS.screen))
	
	set_bus_volume("Master", settings.get("master_volume", DEFAULTS.master_volume))
	set_bus_volume("song", settings.get("song_volume", DEFAULTS.song_volume))
	set_bus_volume("sfx", settings.get("sfx_volume", DEFAULTS.sfx_volume))

func set_bus_volume(bus_name: String, db: float):
	var bus_idx = AudioServer.get_bus_index(bus_name)
	if bus_idx != -1:
		AudioServer.set_bus_volume_db(bus_idx, db)
