extends CanvasLayer

onready var continueButton = $MarginContainer/MarginContainer/VBoxContainer/ContinueButton
onready var optionsButton = $MarginContainer/MarginContainer/VBoxContainer/OptionsButton
onready var exitButton = $MarginContainer/MarginContainer/VBoxContainer/ExitButton
onready var exitGameButton = $MarginContainer/MarginContainer/VBoxContainer/ExitGameButton

onready var marginContainer = $MarginContainer

var optionsMenuScene = preload("res://UI/OptionsMenu/OptionsMenu.tscn")

func _ready():
	continueButton.connect("pressed", self, "on_continue_button_pressed")
	exitButton.connect("pressed", self, "on_exit_button_pressed") 
	optionsButton.connect("pressed", self, "on_options_pressed")
	exitGameButton.connect("pressed", self, "on_exit_game_button_pressed")
	
	get_tree().paused = true

func _unhandled_input(event):
	if event.is_action_pressed("pause_menu") && marginContainer.visible:
		unpause()
		get_tree().set_input_as_handled()
		
func on_continue_button_pressed():
	unpause()

func on_exit_button_pressed():
	unpause()
	Global.door_name = null
	var _scene = get_tree().change_scene("res://UI/GameMenu/GameMenu.tscn")

func on_exit_game_button_pressed():
	get_tree().quit()

func unpause():
	queue_free()
	get_tree().paused = false
	
### Options menu ###
	
func on_options_pressed():
	var optionsMenuInstance = optionsMenuScene.instance()
	get_tree().root.add_child(optionsMenuInstance)
	optionsMenuInstance.connect("back_pressed", self, "on_options_back_pressed")
	marginContainer.visible = false

func on_options_back_pressed():
	marginContainer.visible = true
