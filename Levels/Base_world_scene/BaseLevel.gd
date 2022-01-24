extends Node

var pauseMenu 					= preload("res://UI/PauseMenu/PauseMenu.tscn")
var bookMenu						= preload("res://UI/BookMenu/BookMenu.tscn")

onready var player 				= get_node("Player")

onready var animationPlayer 		= $AnimationPlayer
onready var page_collectable 	= $Collectables/Page

######## LifeCycle ########

func _ready():
	FileManager.current_level = get_tree().get_current_scene().get_name()
	FileManager.load_game()
	correct_player_position_by_door()
	
	page_collectable.connect("page_collected", self, "on_page_collected")
	
func _unhandled_input(event):
	if event.is_action_pressed("pause_menu"):
		#save_game()
		var pauseInstance = pauseMenu.instance()
		add_child(pauseInstance)
	elif event.is_action_pressed("book_menu"):
		var bookInstance = bookMenu.instance()
		add_child(bookInstance)

###### Level Events Logic #########

func on_page_collected():
	animationPlayer.play("Gate_opening_cut_scene")
	
###### Helpers #########

func save_game():
	FileManager.save_game()
	
func correct_player_position_by_door():
	if Global.door_name:
		var door_node = find_node(Global.door_name)
		if door_node:
			player.global_position = door_node.global_position
			$Camera2D.global_position = door_node.global_position
