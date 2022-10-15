extends Node2D

export(String, FILE, "*.tscn, *scn") var nextScenePath
export(String) var nextDoorName = "-"

onready var interactionController = $InteractionController
onready var interactionPopup = $InteractionPopup
onready var animationPlayer = $AnimationPlayer
onready var gateSign = $GatesText

export var isAbleToTransition = false

func _ready():
	interactionController.disabled(true)
	interactionController.connect("on_approach", self, "on_player_entered")
	interactionController.connect("on_leave", self, "on_player_exited")
	
	interactionController.connect("on_interact", self, "_on_interact")
	
	if GameEventConstants.constants.has("is_start_gate_open") and GameEventConstants.constants["is_start_gate_open"]:
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

func on_player_entered(body):
	if "is_entering_out" in body && body.is_entering_out == false:
		interactionPopup.show()
	isAbleToTransition = true
	
func on_player_exited():
	interactionPopup.hide()
	isAbleToTransition = false

func _on_interact(_body):
	interactionPopup.hide()
	Global.door_name = nextDoorName
	EventBus.player_entered_door(nextScenePath)
