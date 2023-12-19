extends Node2D

onready var game_menu_path = "res://Project/UI/Screens/GameMenu/GameMenu.tscn"

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func loadMainMenu():
	var _scene = get_tree().change_scene(game_menu_path)
