extends Node2D

export(Array, String, MULTILINE) var texts_array 
export(float) var charReadRate = 0.02

onready var interactionPopup = $InteractionPopup
onready var textBoxPopup = $TextBoxPopup
onready var interactionController = $InteractionController

func _ready():
	textBoxPopup.CHAR_READ_RATE = charReadRate
	textBoxPopup.texts_array = texts_array
	
	interactionController.connect("on_approach", self, "on_player_entered")
	interactionController.connect("on_interact", self, "on_player_interacted")
	interactionController.connect("on_leave", self, "on_player_leave")

func on_player_entered(_body):
	interactionPopup.show()
	
func on_player_interacted(_body):
	interactionPopup.hide()
	
func on_player_leave():
	interactionPopup.hide()
