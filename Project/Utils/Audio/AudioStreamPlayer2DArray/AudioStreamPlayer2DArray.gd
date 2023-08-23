extends Node2D

func set_play_mode(activate: bool):
	for child in get_children():
		child.autoplay = activate
		child.playing = activate
