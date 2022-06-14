extends Node2D

export(String, FILE, "*.tscn, *scn") var nextScenePath
export(String) var nextDoorName = "-"

onready var area2d = $Area2D
onready var interactionController = $InteractionController

export var isAbleToTransition = false
export var isOpened = false

func _ready():
	interactionController.disabled(true)
	area2d.connect("body_entered", self, "on_player_entered")
	area2d.connect("body_exited", self, "on_player_exited")
	
	interactionController.connect("on_interact", self, "_on_interact")
	
	if isOpened:
		interactionController.disabled(false)
		$AnimationPlayer.play("Opened")

func on_open_gates_call():
	isOpened = true
	$AnimationPlayer.play("Open")
	interactionController.disabled(false)

# Area2D functions

func on_player_entered(_body):
	isAbleToTransition = true
	
func on_player_exited(_body):
	isAbleToTransition = false

func _on_interact():
	Global.door_name = nextDoorName
	
	EventBus.player_entered_door(nextScenePath)
