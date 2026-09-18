extends Node

const SETTINGS_PATH = "user://settings.json"
const MIN_VOLUME_DB := -80.0
const MAX_VOLUME_DB := 0.0

var settings: Dictionary = {}

const DEFAULTS = {
	"master_volume": 0.0,
	"song_volume": -10.0,
	"sfx_volume": -8.0,
	"v_sync": DisplayServer.VSYNC_ADAPTIVE,
	"screen": DisplayServer.WINDOW_MODE_FULLSCREEN
}

func _ready() -> void:
	load_settings()

func load_settings() -> void:
	settings = DEFAULTS.duplicate(true)
	var should_save := not FileAccess.file_exists(SETTINGS_PATH)

	if not should_save:
		var file := FileAccess.open(SETTINGS_PATH, FileAccess.READ)
		if file == null:
			push_warning("Não foi possível abrir o arquivo de configurações. Usando os valores padrão.")
			should_save = true
		else:
			var data = JSON.parse_string(file.get_as_text())
			if data is Dictionary:
				for key in DEFAULTS:
					if not data.has(key):
						should_save = true
				settings.merge(data, true)
			else:
				push_warning("Arquivo de configurações inválido. Restaurando os valores padrão.")
				should_save = true

	if _sanitize_settings():
		should_save = true

	apply_all_settings()

	if should_save:
		save_settings()

func save_settings() -> bool:
	var file := FileAccess.open(SETTINGS_PATH, FileAccess.WRITE)
	if file == null:
		push_error("Não foi possível salvar o arquivo de configurações.")
		return false

	file.store_string(JSON.stringify(settings, "\t"))
	print("Configurações salvas.")
	return true

func apply_all_settings() -> void:
	DisplayServer.window_set_vsync_mode(settings.get("v_sync", DEFAULTS.v_sync))
	DisplayServer.window_set_mode(settings.get("screen", DEFAULTS.screen))
	
	set_bus_volume("Master", settings.get("master_volume", DEFAULTS.master_volume))
	set_bus_volume("song", settings.get("song_volume", DEFAULTS.song_volume))
	set_bus_volume("sfx", settings.get("sfx_volume", DEFAULTS.sfx_volume))

func set_bus_volume(bus_name: String, db: float) -> void:
	var bus_idx := AudioServer.get_bus_index(bus_name)
	if bus_idx != -1:
		AudioServer.set_bus_volume_db(bus_idx, db)

func _sanitize_settings() -> bool:
	var was_changed := false

	for key in ["master_volume", "song_volume", "sfx_volume"]:
		var value = settings.get(key)
		if typeof(value) != TYPE_INT and typeof(value) != TYPE_FLOAT:
			settings[key] = DEFAULTS[key]
			was_changed = true
			continue

		var sanitized_value := clampf(float(value), MIN_VOLUME_DB, MAX_VOLUME_DB)
		if sanitized_value != value:
			was_changed = true
		settings[key] = sanitized_value

	var valid_vsync_modes := [
		DisplayServer.VSYNC_DISABLED,
		DisplayServer.VSYNC_ENABLED,
		DisplayServer.VSYNC_ADAPTIVE,
		DisplayServer.VSYNC_MAILBOX
	]
	var v_sync = settings.get("v_sync")
	if (
		typeof(v_sync) != TYPE_INT
		and typeof(v_sync) != TYPE_FLOAT
	) or int(v_sync) not in valid_vsync_modes:
		settings["v_sync"] = DEFAULTS.v_sync
		was_changed = true
	else:
		settings["v_sync"] = int(v_sync)

	var valid_window_modes := [
		DisplayServer.WINDOW_MODE_WINDOWED,
		DisplayServer.WINDOW_MODE_MINIMIZED,
		DisplayServer.WINDOW_MODE_MAXIMIZED,
		DisplayServer.WINDOW_MODE_FULLSCREEN,
		DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN
	]
	var screen = settings.get("screen")
	if (
		typeof(screen) != TYPE_INT
		and typeof(screen) != TYPE_FLOAT
	) or int(screen) not in valid_window_modes:
		settings["screen"] = DEFAULTS.screen
		was_changed = true
	else:
		settings["screen"] = int(screen)

	return was_changed
