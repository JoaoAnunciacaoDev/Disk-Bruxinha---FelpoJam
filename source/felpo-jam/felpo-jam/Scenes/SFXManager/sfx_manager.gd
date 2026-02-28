extends Node
class_name SFXManager

@export var sounds : Dictionary[String, AudioStream]

func play_sfx(sfx_name : String) -> void:
	if not sounds.has(sfx_name): return
	
	var asp : AudioStreamPlayer = AudioStreamPlayer.new()
	asp.stream = sounds[sfx_name]
	asp.bus = "sfx"
	asp.pitch_scale = randf_range(0.9, 1.1)
	add_child(asp)
	asp.play()
	await asp.finished
	asp.queue_free()
