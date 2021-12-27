extends Node

var pauseMenu = preload("res://UI/PauseMenu/PauseMenu.tscn")

func _ready():
	pass 

func _unhandled_input(event):
	if event.is_action_pressed("pause_menu"):
		var pauseInstance = pauseMenu.instance()
		add_child(pauseInstance)
