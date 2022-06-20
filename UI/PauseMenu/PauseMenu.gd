extends CanvasLayer

onready var continueButton = $MainMarginContainer/MarginContainer/ContentVBoxContainer/MenuVBoxContainer/OptionButtonsVBoxContainer/ContinueButton
onready var optionsButton = $MainMarginContainer/MarginContainer/ContentVBoxContainer/MenuVBoxContainer/OptionButtonsVBoxContainer/OptionsButton
onready var exitButton = $MainMarginContainer/MarginContainer/ContentVBoxContainer/MenuVBoxContainer/OptionButtonsVBoxContainer/ExitButton
onready var exitGameButton = $MainMarginContainer/MarginContainer/ContentVBoxContainer/MenuVBoxContainer/ExitGameButton

onready var marginContainer = $MainMarginContainer

var optionsMenuScene = preload("res://UI/OptionsMenu/OptionsMenu.tscn")

func _ready():
	continueButton.connect("pressed", self, "on_continue_button_pressed")
	exitButton.connect("pressed", self, "on_exit_button_pressed") 
	optionsButton.connect("pressed", self, "on_options_pressed")
	exitGameButton.connect("pressed", self, "on_exit_game_button_pressed")
	
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

func on_exit_game_button_pressed():
	get_tree().quit()

func unpause():
	queue_free()
	get_tree().paused = false
	
### Options menu ###
	
func on_options_pressed():
	var optionsMenuInstance = optionsMenuScene.instance()
	add_child(optionsMenuInstance)
	optionsMenuInstance.connect("back_pressed", self, "on_options_back_pressed")
	marginContainer.visible = false

func on_options_back_pressed():
	marginContainer.visible = true
