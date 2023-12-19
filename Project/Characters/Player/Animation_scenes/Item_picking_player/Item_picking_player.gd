extends Node2D

signal animationFinished

onready var itemPosition = $ItemPosition

var itemScene

func _ready():
	if itemScene == null:
		return
	var item_instance = itemScene.instance()
	add_child(item_instance)
	item_instance.global_position = itemPosition.global_position
	MusicPlayer.set_background_music_volumeDB(-25.0)

func finish_animation():
	emit_signal("animationFinished")
	MusicPlayer.set_background_music_volumeDB(0.0)
	queue_free()
