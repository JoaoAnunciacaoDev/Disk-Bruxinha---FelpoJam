extends Control

signal back_pressed

@export var master_slider : HSlider
@export var song_slider : HSlider
@export var sfx_slider : HSlider

func _ready() -> void:
	load_current_settings_to_ui()

func load_current_settings_to_ui() -> void:
	var settings_ref = SettingsManager.settings
	master_slider.value = db_to_linear(settings_ref.get("master_volume", SettingsManager.DEFAULTS.master_volume))
	song_slider.value = db_to_linear(settings_ref.get("song_volume", SettingsManager.DEFAULTS.song_volume))
	sfx_slider.value = db_to_linear(settings_ref.get("sfx_volume", SettingsManager.DEFAULTS.sfx_volume))

func _on_master_value_changed(value: float) -> void:
	var db = linear_to_db(value)
	SettingsManager.settings["master_volume"] = db
	SettingsManager.set_bus_volume("Master", db)
	SfxManager.play_sfx("button_pressed")

func _on_song_value_changed(value: float) -> void:
	var db = linear_to_db(value)
	SettingsManager.settings["song_volume"] = db
	SettingsManager.set_bus_volume("song", db)
	SongManager.player.volume_db = db
	SfxManager.play_sfx("button_pressed")

func _on_sfx_value_changed(value: float) -> void:
	var db = linear_to_db(value)
	SettingsManager.settings["sfx_volume"] = db
	SettingsManager.set_bus_volume("sfx", db)
	SfxManager.play_sfx("button_pressed")

func _on_window_options_item_selected(index: int) -> void:
	match index:
		0:
			SettingsManager.settings["screen"] = DisplayServer.WINDOW_MODE_WINDOWED
		1:
			SettingsManager.settings["screen"] =  DisplayServer.WINDOW_MODE_FULLSCREEN
		2:
			SettingsManager.settings["screen"] = DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN
		_:
			SettingsManager.settings["screen"] = DisplayServer.WINDOW_MODE_FULLSCREEN
	
	DisplayServer.window_set_mode(SettingsManager.settings["screen"])
	SettingsManager.save_settings()
	SfxManager.play_sfx("button_pressed")

func _on_v_sync_option_item_selected(index: int) -> void:
	match index:
		0:
			SettingsManager.settings["v_sync"] = DisplayServer.VSYNC_DISABLED
		1:
			SettingsManager.settings["v_sync"] = DisplayServer.VSYNC_ENABLED
		2:
			SettingsManager.settings["v_sync"] = DisplayServer.VSYNC_ADAPTIVE
		_:
			SettingsManager.settings["v_sync"] = DisplayServer.VSYNC_ADAPTIVE
	
	DisplayServer.window_set_vsync_mode(SettingsManager.settings["v_sync"])
	SettingsManager.save_settings()
	SfxManager.play_sfx("button_pressed")

func _on_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		SettingsManager.save_settings()
	
	SfxManager.play_sfx("button_pressed")

func _on_back_button_pressed() -> void:
	hide()
	emit_signal("back_pressed")
	SfxManager.play_sfx("button_pressed")
