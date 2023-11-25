extends Node

onready var audioStreamPlayer = $AudioStreamPlayer

func play_stream(stream):
	if stream:
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
