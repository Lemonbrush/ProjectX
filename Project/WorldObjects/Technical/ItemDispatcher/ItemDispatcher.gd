extends Node

export(PackedScene) var itemScene

func dispatch():
	var item_instance = itemScene.instance()
	if item_instance && item_instance.has_method("pick_up_item"):
		item_instance.pick_up_item()
