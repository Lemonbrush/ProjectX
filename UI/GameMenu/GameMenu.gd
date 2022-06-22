extends CanvasLayer

onready var play_button = $MainMenuMarginContainer/VBoxContainer/PlayButton
onready var options_button = $MainMenuMarginContainer/VBoxContainer/OptionsButton
onready var exit_button = $MainMenuMarginContainer/VBoxContainer/ExitButton
onready var version_label = $RightMarginContainer/VersionLabel

onready var mainMenuMarginContainer = $MainMenuMarginContainer

var optionsMenuScene = preload("res://UI/OptionsMenu/OptionsMenu.tscn")

func _ready():
	play_button.connect("pressed", self, "on_play_pressed")
	exit_button.connect("pressed", self, "on_exit_pressed")
	options_button.connect("pressed", self, "on_options_pressed")
	version_label.text = FileManager.get_project_version()
	
func on_play_pressed():
	FileManager.load_game()
	
func on_exit_pressed():
	get_tree().quit()

func on_options_pressed():
	var optionsMenuInstance = optionsMenuScene.instance()
	get_tree().root.add_child(optionsMenuInstance)
	optionsMenuInstance.connect("back_pressed", self, "on_options_back_pressed")
	mainMenuMarginContainer.visible = false

func on_options_back_pressed():
	mainMenuMarginContainer.visible = true
