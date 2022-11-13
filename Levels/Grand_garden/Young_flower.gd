extends Node2D

signal interacted_with_args(args)

onready var interactionPopup = $Upper_background_objects/Young_flower/InteractionPopup
onready var interactionController = $Upper_background_objects/Young_flower/InteractionController

func _ready():
	interactionController.connect("on_approach", self, "on_player_entered")
	interactionController.connect("on_interact", self, "on_player_interacted")
	interactionController.connect("on_leave", self, "on_player_leave")

func on_player_entered(_body):
	interactionPopup.show()
	
func on_player_interacted(_body):
	interactionPopup.hide()
	
func on_player_leave():
	interactionPopup.hide()
