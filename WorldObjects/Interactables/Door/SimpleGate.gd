extends Node2D

export(String, FILE, "*.tscn, *scn") var nextScenePath
export(String) var nextDoorName

onready var interactionController = $InteractionController
onready var interactionPopup = $InteractionPopup

func _ready():
	interactionController.connect("on_interact", self, "_on_interact")
	interactionController.connect("on_approach", self, "_on_player_entered")
	interactionController.connect("on_leave", self, "_on_player_exited")

func _on_player_entered(body):
	if "is_entering_out" in body && body.is_entering_out == false:
		interactionPopup.show()
	
func _on_player_exited():
	interactionPopup.hide()

func _on_interact(body):
	interactionPopup.hide()
	Global.door_name = nextDoorName
	body.global_position = global_position
	EventBus.player_entered_door(nextScenePath)
