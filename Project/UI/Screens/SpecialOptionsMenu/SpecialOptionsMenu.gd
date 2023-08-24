extends CanvasLayer
signal back_pressed

onready var mainMarginContainer = $MainMarginContainer
onready var quitButton = $MainMarginContainer/MarginContainer/ContentVBoxContainer/OptionsVBoxContainer/ExitButton
onready var deleteAllSavesButton = $MainMarginContainer/MarginContainer/ContentVBoxContainer/OptionsVBoxContainer/DeleteAllSavesButton
onready var deleteSettingsDataButton = $MainMarginContainer/MarginContainer/ContentVBoxContainer/OptionsVBoxContainer/DeleteSystemDataButton

onready var resetGameConstantsButton = $MainMarginContainer/MarginContainer/ContentVBoxContainer/OptionsVBoxContainer/ResetGameConstantsButton
onready var deleteAllSavesByDefaultRadiobutton = $MainMarginContainer/MarginContainer/ContentVBoxContainer/OptionsVBoxContainer/DeleteAllSavesAlwaysButton
onready var activateDebugScreenRadiobutton = $MainMarginContainer/MarginContainer/ContentVBoxContainer/OptionsVBoxContainer/ActivateDebugScreenButton
onready var gameConstsEditorButton = $MainMarginContainer/MarginContainer/ContentVBoxContainer/OptionsVBoxContainer/GameConstsEditorButton

var gameConstsEditorMenu = load("res://Project/UI/Screens/GameConstsEditor/GameConstsEditor.tscn")

func _ready():
	quitButton.connect("pressed_and_resolved", self, "on_quit_pressed") 
	deleteAllSavesButton.connect("pressed_and_resolved", self, "on_save_delete_pressed") 
	deleteAllSavesByDefaultRadiobutton.connect("pressed_and_resolved", self, "on_delete_all_saves_by_default_radiobutton_checked")
	deleteSettingsDataButton.connect("pressed_and_resolved", self, "on_delete_settings_data_pressed")
	activateDebugScreenRadiobutton.connect("pressed_and_resolved", self, "on_debug_screen_radiobutton_pressed")
	resetGameConstantsButton.connect("pressed_and_resolved", self, "on_reset_game_constants_pressed")
	gameConstsEditorButton.connect("pressed_and_resolved", self, "on_special_options_pressed") 
	
	setup_ui()
	quitButton.grab_focus_without_animation()

func _unhandled_input(event):
	if event.is_action_pressed("pause_menu") and mainMarginContainer.visible:
		on_quit_pressed()

func setup_ui():
	deleteSettingsDataButton.disabled = !SettingsManager.has_settings_file()
	deleteAllSavesButton.disabled = !FileManager.has_any_save_file()
	
	deleteAllSavesByDefaultRadiobutton.pressed = SettingsManager.settings.should_delete_all_saves_on_start_session
	activateDebugScreenRadiobutton.pressed = SettingsManager.settings.is_debug_screen_active
	
	EventBus.did_update_cursor_setting()
	EventBus.debug_screen_visibility_updated()

func on_quit_pressed():
	queue_free()
	emit_signal("back_pressed")

func on_save_delete_pressed():
	FileManager.delete_save()
	EventBus.did_reset_game_constants()
	setup_ui()

func on_delete_all_saves_by_default_radiobutton_checked():
	SettingsManager.update_should_delete_all_saves_on_start_session_option()
	setup_ui()
	
func on_delete_settings_data_pressed():
	SettingsManager.delete_settings_save()
	setup_ui()

func on_debug_screen_radiobutton_pressed():
	SettingsManager.update_debug_screen_option()
	setup_ui()

func on_special_options_pressed():
	var gameConstsEditorMenuInstance = gameConstsEditorMenu.instance()
	get_tree().root.add_child(gameConstsEditorMenuInstance)
	gameConstsEditorMenuInstance.connect("back_pressed", self, "on_options_back_pressed")
	mainMarginContainer.visible = false

func on_options_back_pressed():
	mainMarginContainer.visible = true
	quitButton.grab_focus_without_animation()

func on_reset_game_constants_pressed():
	GameEventConstants.set_default_constants()
	FileManager.save_game()
	EventBus.did_reset_game_constants()
