extends Node2D

export var autoplay = true

onready var audio_player = $AudioStreamPlayer2D

func _ready():
	set_autoplay(autoplay)

func set_autoplay(autoplay: bool):
	audio_player.autoplay = autoplay
