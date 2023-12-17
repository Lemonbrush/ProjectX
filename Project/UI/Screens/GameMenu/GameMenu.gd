extends Node2D

export (AudioStreamSample) var background_music

onready var new_game_button = $CanvasLayer/MainMenuMarginContainer/VBoxContainer/PlayButton
onready var options_button = $CanvasLayer/MainMenuMarginContainer/VBoxContainer/OptionsButton
onready var exit_button = $CanvasLayer/MainMenuMarginContainer/VBoxContainer/ExitButton
onready var version_label = $CanvasLayer/RightMarginContainer/VersionLabel
onready var about_button = $CanvasLayer/MainMenuMarginContainer/VBoxContainer/AboutButton
onready var continue_button = $CanvasLayer/MainMenuMarginContainer/VBoxContainer/ContinueButton
onready var buttons_container = $CanvasLayer/MainMenuMarginContainer/VBoxContainer

onready var mainMenuCanvasLayer = $CanvasLayer
onready var logo_animation_player = $AnimationPlayer

var optionsMenuScene = preload("res://Project/UI/Screens/OptionsMenu/OptionsMenu.tscn")
var changelogMenuScene = preload("res://Project/UI/Screens/DevelopmentLogMenu/DevelopmentLogMenu.tscn")
var transition_background_music = preload("res://Assets/Audio/SFX/General/Shine/shiny-object.wav")

func _ready():
	Global.is_game_loaded = false
	
	var _continue_button_connection = continue_button.connect("pressed_and_resolved", self, "on_continue_button_pressed") 
	var _new_game_button_connection = new_game_button.connect("pressed_and_resolved", self, "on_new_game_button_pressed")
	var _exit_button_connection = exit_button.connect("pressed_and_resolved", self, "on_exit_pressed")
	var _options_button_connection = options_button.connect("pressed_and_resolved", self, "on_options_pressed")
	var _about_button_connection = about_button.connect("pressed_and_resolved", self, "on_changelog_pressed")
	update_ui_data()
	play_background_music()
	

func update_ui_data():
	version_label.text = FileManager.get_project_version()
	continue_button.visible = FileManager.has_any_save_file()
	grab_first_button_focus()
	link_buttons_focus()

func link_buttons_focus():
	var first_button
	var last_button
	for button in buttons_container.get_children():
		if button is Button and button.visible:
			last_button = button
			if first_button == null:
				first_button = button
	
	if first_button != null and last_button != null:
		first_button.focus_neighbour_top = NodePath(last_button.get_path())
		last_button. focus_neighbour_bottom = NodePath(first_button.get_path())
	
func grab_first_button_focus():
	for button in buttons_container.get_children():
		if button is Button and button.visible:
			button.grab_focus_without_animation()
			return

func on_new_game_button_pressed():
	new_game_button.disabled = true
	FileManager.delete_save()
	EventBus.did_reset_game_constants()
	logo_animation_player.play("Play")
	
func on_continue_button_pressed():
	continue_button.disabled = true
	logo_animation_player.play("Play")

func logo_hide_animation_finished():
	stop_background_music()
	FileManager.load_game()
	
func on_exit_pressed():
	stop_background_music()
	get_tree().quit()

func on_options_pressed():
	var optionsMenuInstance = optionsMenuScene.instance()
	get_tree().root.add_child(optionsMenuInstance)
	optionsMenuInstance.connect("back_pressed", self, "on_options_back_pressed")
	mainMenuCanvasLayer.visible = false
	
func on_changelog_pressed():
	mainMenuCanvasLayer.visible = false
	var changelogMenuSceneInstance = changelogMenuScene.instance()
	get_tree().root.add_child(changelogMenuSceneInstance)
	changelogMenuSceneInstance.connect("back_pressed", self, "on_options_back_pressed")

func on_options_back_pressed():
	update_ui_data()
	mainMenuCanvasLayer.visible = true

func play_background_music():
	MusicPlayer.reset_background_music_volumeDB()
	MusicPlayer.play_stream(background_music)

func play_transition_music():
	MusicPlayer.smooth_music_change(transition_background_music)

func stop_background_music():
	MusicPlayer.stop()
