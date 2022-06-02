extends Node2D

export (PackedScene) var openAnimationScene
export (PackedScene) var innerItemScene

onready var interactionController = $InteractionController

func _ready():
	interactionController.connect("on_interact", self, "_on_open_pressed") 

func _on_open_pressed():
	var openAnimationSceneInstance = openAnimationScene.instance()
	get_parent().add_child_below_node(self, openAnimationSceneInstance)
	openAnimationSceneInstance.global_position = global_position
	drop_item()
	queue_free()
	
func drop_item():
	if innerItemScene:
		var innerItemSceneInstance = innerItemScene.instance()
		innerItemSceneInstance.set_position(position)
		get_parent().call_deferred("add_child", innerItemSceneInstance)
		if innerItemSceneInstance.has_method("drop"):
			innerItemSceneInstance.call_deferred("drop")
