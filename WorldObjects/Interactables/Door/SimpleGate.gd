extends Node2D

export(String, FILE, "*.tscn, *scn") var nextScenePath
export(String) var nextDoorName

onready var interactionController = $InteractionController
onready var area2d = $Area2D

var isAbleToTransition = false

func _ready():
	area2d.connect("body_entered", self, "on_player_entered")
	area2d.connect("body_exited", self, "on_player_exited")
	
	interactionController.connect("on_interact", self, "_on_interact")

func on_player_entered(_body):
	isAbleToTransition = true
	
func on_player_exited(_body):
	isAbleToTransition = false

func _on_interact(_body):
	Global.door_name = nextDoorName
	EventBus.player_entered_door(nextScenePath)
