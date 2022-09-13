extends Node2D

export (PackedScene) var openAnimationScene
export (PackedScene) var innerItemScene

onready var interactionController = $InteractionController
onready var interactionPopup = $InteractionPopup

func _ready():
	interactionController.connect("on_interact", self, "_on_open_pressed") 
	interactionController.connect("on_approach", self, "_on_player_enter")

func _on_open_pressed(_body):
	var openAnimationSceneInstance = openAnimationScene.instance()
	get_parent().add_child_below_node(self, openAnimationSceneInstance)
	openAnimationSceneInstance.set_owner(get_tree().get_current_scene())
	openAnimationSceneInstance.global_position = global_position
	openAnimationSceneInstance.innerItemScene = innerItemScene
	queue_free()

func _on_player_enter(_body):
	interactionPopup.show()
