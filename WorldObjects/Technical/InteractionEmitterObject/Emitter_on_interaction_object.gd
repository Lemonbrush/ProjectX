extends Node2D

signal interacted_with_arg(arg)

export(String) var emitting_arg

onready var interactionPopup = $InteractionPopup
onready var interactionController = $InteractionController

func _ready():
	interactionController.connect("on_approach", self, "on_player_entered")
	interactionController.connect("on_interact", self, "on_player_interacted")
	interactionController.connect("on_leave", self, "on_player_leave")

func on_player_entered(_body):
	interactionPopup.show()
	
func on_player_interacted(_body):
	interactionPopup.hide()
	emit_signal("interacted_with_arg", emitting_arg)
	
func on_player_leave():
	interactionPopup.hide()
