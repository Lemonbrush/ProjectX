extends Node
class_name BaseLevel

var pauseMenu 					= preload("res://UI/PauseMenu/PauseMenu.tscn")
var bookMenu						= preload("res://UI/BookMenu/BookMenu.tscn")

onready var player 				= get_node("Player")
onready var camera				= $Camera2D

######## LifeCycle ########

func _ready():
	FileManager.current_level = get_tree().get_current_scene().get_name()
	FileManager.load_game(correct_player_position_by_door())
	
func _unhandled_input(event):
	if event.is_action_pressed("pause_menu"):
		save_game()
		var pauseInstance = pauseMenu.instance()
		add_child(pauseInstance)
	elif event.is_action_pressed("book_menu"):
		save_game()
		var bookInstance = bookMenu.instance()
		add_child(bookInstance)
	
###### Helpers #########

func save_game():
	FileManager.save_game()
	
func correct_player_position_by_door():
	if Global.door_name:
		var door_node = find_node(Global.door_name)
		if door_node:
			print("searching for door named - ", Global.door_name)
			player.global_position = door_node.global_position
			camera.global_position = door_node.global_position
			return door_node.global_position
