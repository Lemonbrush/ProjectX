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
