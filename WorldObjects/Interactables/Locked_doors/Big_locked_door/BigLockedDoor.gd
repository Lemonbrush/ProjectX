extends Node2D

export(String, FILE, "*.tscn, *scn") var nextScenePath
export(String) var nextDoorName
export(bool) var isLocked = true
export(String) var keyGameConstant

onready var interactionController = $InteractionController
onready var unlockDoorPopup = $UnlockDoorInteractionPopup
onready var enterDoorPopup = $EnterDoorInteractionPopup
onready var animationPlayer = $AnimationPlayer

var isAbleToTransition = false

func _ready():
	interactionController.connect("on_interact", self, "_on_interact")
	
	if isLocked:
		animationPlayer.play("Idle")
	else:
		animationPlayer.play("Opened")

func _on_interact(_body):
	var could_be_opened = false
	
	if keyGameConstant == null || get_game_constant_value_by_string(keyGameConstant):
		could_be_opened = true
	
	if isLocked:
		try_to_open_door(could_be_opened)
	else:
		enter_door()

func get_game_constant_value_by_string(keyGameConstant):
	if !GameEventConstants.constants.has(keyGameConstant):
		return false
	return GameEventConstants.constants[keyGameConstant]

func try_to_open_door(could_be_opened):
	if could_be_opened:
		isLocked = false
		animationPlayer.play("Open")

func enter_door():
	Global.door_name = nextDoorName
	EventBus.player_entered_door(nextScenePath)
