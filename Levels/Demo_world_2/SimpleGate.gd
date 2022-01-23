extends Node2D

export(String, FILE, "*.tscn, *scn") var nextScenePath
export(String) var nextDoorName

onready var area2d = $Area2D

var isAbleToTransition = false

func _ready():
	area2d.connect("body_entered", self, "on_player_entered")
	area2d.connect("body_exited", self, "on_player_exited")
		
func _input(event):
	if event.is_action_pressed("jump") && isAbleToTransition:
		Global.door_name = nextDoorName
		print("This door is connected to ", nextDoorName)
		
		LevelManager.transition_to_level(nextScenePath)

func on_player_entered(_body):
	isAbleToTransition = true
	
func on_player_exited(_body):
	isAbleToTransition = false 
