extends Node2D

export (PackedScene) var openAnimationScene
export (PackedScene) var innerItemScene

onready var interactionController = $InteractionController

func _ready():
	interactionController.connect("on_interact", self, "_on_open_pressed") 

func _on_open_pressed():
	var openAnimationSceneInstance = openAnimationScene.instance()
	get_tree().get_current_scene().add_child(openAnimationSceneInstance)
	openAnimationSceneInstance.global_position = global_position
	drop_item()
	queue_free()
	
func drop_item():
	if innerItemScene:
		var innerItemSceneInstance = innerItemScene.instance()
		innerItemSceneInstance.set_position(position)

		# we have to add children to the root node in order to let them be packed in save scene
		get_tree().get_current_scene().call_deferred("add_child", innerItemSceneInstance)
		
		if innerItemSceneInstance.has_method("drop"):
			innerItemSceneInstance.call_deferred("drop")
