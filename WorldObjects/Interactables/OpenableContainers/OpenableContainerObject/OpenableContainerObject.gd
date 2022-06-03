extends Node2D

export (PackedScene) var openAnimationScene
export (PackedScene) var innerItemScene

onready var interactionController = $InteractionController

func _ready():
	interactionController.connect("on_interact", self, "_on_open_pressed") 

func _on_open_pressed():
	var openAnimationSceneInstance = openAnimationScene.instance()
	get_parent().add_child_below_node(self, openAnimationSceneInstance)
	openAnimationSceneInstance.set_owner(get_tree().get_current_scene())
	openAnimationSceneInstance.global_position = global_position
	openAnimationSceneInstance.innerItemScene = innerItemScene
	queue_free()
