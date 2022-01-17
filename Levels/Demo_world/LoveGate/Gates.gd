extends Node2D

onready var area2d = $Area2D

var isAbleToTransition = false

func _ready():
	area2d.connect("body_entered", self, "on_player_entered")
	area2d.connect("body_exited", self, "on_player_exited")
		
func _input(event):
	if event.is_action_pressed("jump") && isAbleToTransition:
		var _scene = get_tree().change_scene("res://Levels/Demo_world/DemoWorld.tscn")

func on_open_gates_call():
	$AnimationPlayer.play("Open")

func on_player_entered(_body):
	isAbleToTransition = true
	
func on_player_exited(_body):
	isAbleToTransition = false 
