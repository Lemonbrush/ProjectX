extends Node2D

export(String, FILE, "*.tscn, *scn") var nextScenePath
export(String) var nextDoorName = "-"

onready var area2d = $Area2D
onready var interactionController = $InteractionController
onready var animationPlayer = $AnimationPlayer
onready var gateSign = $GatesText

export var isAbleToTransition = false

func _ready():
	interactionController.disabled(true)
	area2d.connect("body_entered", self, "on_player_entered")
	area2d.connect("body_exited", self, "on_player_exited")
	
	interactionController.connect("on_interact", self, "_on_interact")
	
	if GameEventConstants.constants["is_start_gate_open"]:
		animationPlayer.play("Opened")
		set_gate_opened()

func on_open_gates_call():
	GameEventConstants.set_constant("is_start_gate_open", true)
	animationPlayer.play("Open")
	set_gate_opened()

func set_gate_opened():
	gateSign.visible = false
	interactionController.disabled(false)
	
# Area2D functions

func on_player_entered(_body):
	isAbleToTransition = true
	
func on_player_exited(_body):
	isAbleToTransition = false

func _on_interact(_body):
	Global.door_name = nextDoorName
	EventBus.player_entered_door(nextScenePath)
