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
	setup_ui()

func _unhandled_input(_event):
	if Input.is_action_just_pressed("pause_menu") and marginContainer.visible:
		unpause()
		get_tree().set_input_as_handled()

func setup_ui():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	continueButton.grab_focus_without_animation()
	returnToPedestalHallButton.disabled = get_parent().name == "PedestalHall"
	var is_return_to_pedestal_hall_button_visible = GameEventConstants.get_constant("did_open_pedestal_hall_right_door")
	if is_return_to_pedestal_hall_button_visible == null:
		is_return_to_pedestal_hall_button_visible = false
	returnToPedestalHallButton.visible = is_return_to_pedestal_hall_button_visible
		
func on_continue_button_pressed():
	unpause()

func on_exit_button_pressed():
	Global.reset_state()
	LevelManager.transition_to_level(gameMenuScenePath)

func on_exit_game_button_pressed():
	Global.reset_state()
	get_tree().quit()

func unpause():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	queue_free()
	get_tree().paused = false
	
### Options menu ###

func on_return_to_the_pedestals_pressed():
	Global.reset_state()
	unpause()
	LevelManager.transition_to_level(pedestal_hall_scene_path)
	
func on_options_pressed():
	var optionsMenuInstance = optionsMenuScene.instance()
	add_child(optionsMenuInstance)
	optionsMenuInstance.connect("back_pressed", self, "on_options_back_pressed")
	marginContainer.visible = false

func on_options_back_pressed():
	setup_ui()
	marginContainer.visible = true
	continueButton.grab_focus_without_animation()
