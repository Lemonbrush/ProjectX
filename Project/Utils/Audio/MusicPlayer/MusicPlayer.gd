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
