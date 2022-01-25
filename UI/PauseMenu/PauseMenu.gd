extends CanvasLayer

onready var continueButton = $MarginContainer/MarginContainer/VBoxContainer/ContinueButton
onready var optionsButton = $MarginContainer/MarginContainer/VBoxContainer/OptionsButton
onready var exitButton = $MarginContainer/MarginContainer/VBoxContainer/ExitButton

func _ready():
	continueButton.connect("pressed", self, "on_continue_button_pressed")
	exitButton.connect("pressed", self, "on_exit_button_pressed") 
	
	get_tree().paused = true

func _unhandled_input(event):
	if event.is_action_pressed("pause_menu"):
		unpause()
		get_tree().set_input_as_handled()
		
func on_continue_button_pressed():
	unpause()

func on_exit_button_pressed():
	unpause()
	Global.door_name = null
	var _scene = get_tree().change_scene("res://UI/GameMenu/GameMenu.tscn")

func unpause():
	queue_free()
	get_tree().paused = false
