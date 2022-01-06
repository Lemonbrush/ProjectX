extends Node

var pauseMenu 	= preload("res://UI/PauseMenu/PauseMenu.tscn")
var bookMenu	= preload("res://UI/BookMenu/BookMenu.tscn")

func _ready():
	pass 

func _unhandled_input(event):
	if event.is_action_pressed("pause_menu"):
		var pauseInstance = pauseMenu.instance()
		add_child(pauseInstance)
	elif event.is_action_pressed("book_menu"):
		var bookInstance = bookMenu.instance()
		add_child(bookInstance)
