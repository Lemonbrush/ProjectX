extends Node2D

export(String, FILE, "*.tscn, *scn") var nextScenePath
export(String) var nextDoorName
export(bool) var isLocked = true
export(String) var keyGameConstant

onready var interactionController = $InteractionController
onready var interactionPopup = $InteractionPopup
onready var animationPlayer = $AnimationPlayer

var isAbleToTransition = false

func _ready():
	interactionController.connect("on_interact", self, "_on_interact")
	interactionController.connect("on_approach", self, "_on_approach")
	interactionController.connect("on_leave", self, "_on_leave")
	
	if isLocked:
		animationPlayer.play("Idle")
	else:
		animationPlayer.play("Opened")

func _on_approach(body):
	if !("is_entering_out" in body && body.is_entering_out == false):
		return
	
	if isLocked:
		interactionPopup.show("Открыть")
	else:
		interactionPopup.show("Войти")
	
func _on_leave():
	interactionPopup.hide()
	
func _on_interact(body):
	interactionPopup.hide()
	var could_be_opened = false
	
	if keyGameConstant == null || get_game_constant_value_by_string(keyGameConstant):
		could_be_opened = true
	
	if isLocked:
		try_to_open_door(could_be_opened)
	else:
		enter_door(body)

func get_game_constant_value_by_string(gameConstant):
	if !GameEventConstants.constants.has(gameConstant):
		return false
	return GameEventConstants.constants[gameConstant]

func try_to_open_door(could_be_opened):
	if could_be_opened:
		isLocked = false
		animationPlayer.play("Open")

func enter_door(player):
	Global.door_name = nextDoorName
	player.global_position = global_position
	EventBus.player_entered_door(nextScenePath)
