extends Node

onready var audioStreamPlayer = $AudioStreamPlayer
var music_change_candidate

func play_stream(stream):
	if stream:
		audioStreamPlayer.bus = "Music"
		audioStreamPlayer.stream = stream
		audioStreamPlayer.play()

func play():
	audioStreamPlayer.play()

func stop():
	audioStreamPlayer.stop()

func set_background_music_volumeDB(volumeDB):
	audioStreamPlayer.set_volume_db(volumeDB)

func smooth_stop_music():
	var tween = get_tree().create_tween()
	tween.tween_property(audioStreamPlayer, "volume_db", -30.0, 1)
	tween.play()

func smooth_music_change(stream):
	var tween = get_tree().create_tween()
	tween.tween_property(audioStreamPlayer, "volume_db", -30.0, 1)
	tween.play()
	tween.connect("finished", self, "_smooth_music_change_tween_finished")
	music_change_candidate = stream

func _smooth_music_change_tween_finished():
	play_stream(music_change_candidate)
	music_change_candidate = null
	var tween = get_tree().create_tween()
	tween.tween_property(audioStreamPlayer, "volume_db", SettingsManager.settings.background_music_volume, 0.1)
	tween.play()
