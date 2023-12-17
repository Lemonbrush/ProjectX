extends CanvasLayer

onready var continueButton = $MainMarginContainer/MarginContainer/ContentVBoxContainer/MenuVBoxContainer/ContinueButton
onready var optionsButton = $MainMarginContainer/MarginContainer/ContentVBoxContainer/MenuVBoxContainer/OptionsButton
onready var exitButton = $MainMarginContainer/MarginContainer/ContentVBoxContainer/MenuVBoxContainer/ExitButton
onready var exitGameButton = $MainMarginContainer/MarginContainer/ContentVBoxContainer/MenuVBoxContainer/ExitGameButton
onready var returnToPedestalHallButton = $MainMarginContainer/MarginContainer/ContentVBoxContainer/MenuVBoxContainer/ReturnToPedestalHallButton

onready var marginContainer = $MainMarginContainer

var optionsMenuScene = preload("res://Project/UI/Screens/OptionsMenu/OptionsMenu.tscn")
var gameMenuScenePath = "res://Project/UI/Screens/GameMenu/GameMenu.tscn"
var pedestal_hall_scene_path = "res://Project/Levels/Pedestal_hall/PedestalHall.tscn"

func _ready():
	var _continueButton_connection = continueButton.connect("pressed_and_resolved", self, "on_continue_button_pressed")
	var _exitButton_connection = exitButton.connect("pressed_and_resolved", self, "on_exit_button_pressed") 
	var _optionsButton_connection = optionsButton.connect("pressed_and_resolved", self, "on_options_pressed")
	var _exitGameButton_connection = exitGameButton.connect("pressed_and_resolved", self, "on_exit_game_button_pressed")
	var _pedestalls_connection = returnToPedestalHallButton.connect("pressed_and_resolved", self, "on_return_to_the_pedestals_pressed")
	
	get_tree().paused = true
	continueButton.grab_focus_without_animation()

func _unhandled_input(_event):
	if Input.is_action_just_pressed("pause_menu") and marginContainer.visible:
		unpause()
		get_tree().set_input_as_handled()
		
func on_continue_button_pressed():
	unpause()

func on_exit_button_pressed():
	unpause()
	Global.door_name = null
	var _scene = get_tree().change_scene(gameMenuScenePath)

func on_exit_game_button_pressed():
	get_tree().quit()

func unpause():
	queue_free()
	get_tree().paused = false
	
### Options menu ###

func on_return_to_the_pedestals_pressed():
	LevelManager.transition_to_level(pedestal_hall_scene_path)
	
func on_options_pressed():
	var optionsMenuInstance = optionsMenuScene.instance()
	add_child(optionsMenuInstance)
	optionsMenuInstance.connect("back_pressed", self, "on_options_back_pressed")
	marginContainer.visible = false

func on_options_back_pressed():
	marginContainer.visible = true
	continueButton.grab_focus_without_animation()
