extends Node2D

export(PackedScene) var itemScene

func _ready():
	pass 

func spawn_item():
	if !itemScene:
		return
	
	var item_instance = itemScene.instance()
	add_child(item_instance)
	item_instance.global_position = global_position
	
	if item_instance.has_method("play_show_animation"):
		item_instance.play_show_animation()
