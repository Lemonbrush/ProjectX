extends Node2D

export(String, FILE, "*.tscn, *scn") var nextScenePath
export(String) var nextDoorName = "-"

onready var area2d = $Area2D
export var isAbleToTransition = false
export var isOpened = false

func _ready():
	area2d.connect("body_entered", self, "on_player_entered")
	area2d.connect("body_exited", self, "on_player_exited")
	
	if isOpened:
		$AnimationPlayer.play("Opened")
		
func _input(event):
	if event.is_action_pressed("jump") && isAbleToTransition:
		Global.door_name = nextDoorName
		LevelManager.transition_to_level(nextScenePath)

func on_open_gates_call():
	isOpened = true
	$AnimationPlayer.play("Open")

# Area2D functions

func on_player_entered(_body):
	isAbleToTransition = true
	
func on_player_exited(_body):
	isAbleToTransition = false
