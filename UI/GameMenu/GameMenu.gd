extends CanvasLayer

onready var play_button = $MarginContainer/VBoxContainer/PlayButton
onready var options_button = $MarginContainer/VBoxContainer/OptionsButton
onready var exit_button = $MarginContainer/VBoxContainer/ExitButton

func _ready():
	play_button.connect("pressed", self, "on_play_pressed")
	exit_button.connect("pressed", self, "on_exit_pressed")
	
func on_play_pressed():
	get_tree().change_scene("res://Scenes/WorldScenes/DemoWorld.tscn")
	
func on_exit_pressed():
	get_tree().quit()
