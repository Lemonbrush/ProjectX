extends Node2D

export(String, FILE, "*.tscn, *scn") var nextScenePath
export(String) var nextDoorName = "-"

onready var area2d = $Area2D

var isAbleToTransition = false
var state = false

func _ready():
	area2d.connect("body_entered", self, "on_player_entered")
	area2d.connect("body_exited", self, "on_player_exited")
		
func _input(event):
	if event.is_action_pressed("jump") && isAbleToTransition:
		Global.door_name = nextDoorName
		LevelManager.transition_to_level(nextScenePath)

func on_open_gates_call():
	state = true
	$AnimationPlayer.play("Open")

func on_player_entered(_body):
	isAbleToTransition = true
	
func on_player_exited(_body):
	isAbleToTransition = false 
	
###### Saving #######

func load_state(state):
	if state == true:
		$AnimationPlayer.play("Opened")

func save():
	var save_dict = {
		"objectType" : "Door",
		"filename" : get_filename(),
		"parent" : get_parent().get_path(),
		"pos_x" : position.x, 
		"pos_y" : position.y,
		"z_index" : z_index,
		"state" : state,
		"nextDoorName" : nextDoorName,
		"nextScenePath" : nextScenePath
	}
	return save_dict
