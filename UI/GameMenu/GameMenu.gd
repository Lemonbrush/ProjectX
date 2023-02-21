extends Node2D

onready var play_button = $CanvasLayer/MainMenuMarginContainer/VBoxContainer/PlayButton
onready var options_button = $CanvasLayer/MainMenuMarginContainer/VBoxContainer/OptionsButton
onready var exit_button = $CanvasLayer/MainMenuMarginContainer/VBoxContainer/ExitButton
onready var version_label = $CanvasLayer/RightMarginContainer/VersionLabel
onready var about_button = $CanvasLayer/MainMenuMarginContainer/VBoxContainer/AboutButton

onready var mainMenuMarginContainer = $CanvasLayer/MainMenuMarginContainer
onready var logo_animation_player = $AnimationPlayer

var optionsMenuScene = preload("res://UI/OptionsMenu/OptionsMenu.tscn")
var changelogMenuScene = preload("res://UI/DevelopmentLogMenu/DevelopmentLogMenu.tscn")

func _ready():
	Global.is_game_loaded = false
	
	play_button.connect("pressed", self, "on_play_pressed")
	exit_button.connect("pressed", self, "on_exit_pressed")
	options_button.connect("pressed", self, "on_options_pressed")
	about_button.connect("pressed", self, "on_changelog_pressed")
	version_label.text = FileManager.get_project_version()
	
func on_play_pressed():
	logo_animation_player.play("Play")
	
func load_game():
	FileManager.load_game()
	
func on_exit_pressed():
	get_tree().quit()

func on_options_pressed():
	var optionsMenuInstance = optionsMenuScene.instance()
	get_tree().root.add_child(optionsMenuInstance)
	optionsMenuInstance.connect("back_pressed", self, "on_options_back_pressed")
	mainMenuMarginContainer.visible = false
	
func on_changelog_pressed():
	var changelogMenuSceneInstance = changelogMenuScene.instance()
	get_tree().root.add_child(changelogMenuSceneInstance)
	changelogMenuSceneInstance.connect("back_pressed", self, "on_options_back_pressed")
	mainMenuMarginContainer.visible = false

func on_options_back_pressed():
	mainMenuMarginContainer.visible = true
