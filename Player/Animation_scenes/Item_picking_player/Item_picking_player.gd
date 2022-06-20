extends Node2D

signal animationFinished

onready var itemPosition = $ItemPosition

var itemScene

func _ready():
	var item_instance = itemScene.instance()
	add_child(item_instance)
	item_instance.global_position = itemPosition.global_position

func finish_animation():
	emit_signal("animationFinished")
	queue_free()
