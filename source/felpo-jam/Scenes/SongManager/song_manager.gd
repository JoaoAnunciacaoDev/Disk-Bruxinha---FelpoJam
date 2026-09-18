extends Node

@export var waitDuration: float = 5.0
@export var fadeDuration: float = 2.5

@export var tracks: Dictionary[String, AudioStream] = {}
@export var player : AudioStreamPlayer

var currentTrack: AudioStream = null
var currentPlaylistIndex: int = -1

var playing : bool = true

func _ready():
	start_track_with_fade_in("default_song")

func transition_to_track(trackName: String):
	if not tracks.has(trackName):
		return

	if currentTrack and currentTrack.playing:
		fade_out_current_track(trackName)
	else:
		start_track_with_fade_in(trackName)

func fade_out_current_track(nextTrackName: String):
	if not player:
		return

	var tween = create_tween().set_trans(Tween.TRANS_SINE)
	tween.tween_property(player, "volume_db", -80.0, fadeDuration)
	await tween.finished

	player.stop()
	start_track_with_fade_in(nextTrackName)

func start_track_with_fade_in(trackName: String):
	player.stream = tracks[trackName]
	player.volume_db = -80.0
	player.play()

	var tween = create_tween().set_trans(Tween.TRANS_SINE)
	tween.tween_property(player, "volume_db", 0.0, fadeDuration)
