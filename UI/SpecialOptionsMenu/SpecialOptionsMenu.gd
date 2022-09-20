extends CanvasLayer
signal back_pressed

onready var mainMarginContainer = $MainMarginContainer
onready var quitButton = $MainMarginContainer/MarginContainer/ContentVBoxContainer/MenuVBoxContainer/ExitButton
onready var deleteAllSavesButton = $MainMarginContainer/MarginContainer/ContentVBoxContainer/MenuVBoxContainer/OptionsVBoxContainer/ButtonsVBoxContainer/DeleteAllSavesButton
onready var deleteSettingsDataButton = $MainMarginContainer/MarginContainer/ContentVBoxContainer/MenuVBoxContainer/OptionsVBoxContainer/ButtonsVBoxContainer/DeleteSystemDataButton

onready var resetGameConstantsButton = $MainMarginContainer/MarginContainer/ContentVBoxContainer/MenuVBoxContainer/OptionsVBoxContainer/ButtonsVBoxContainer/ResetGameConstantsButton
onready var deleteAllSavesByDefaultRadiobutton = $MainMarginContainer/MarginContainer/ContentVBoxContainer/MenuVBoxContainer/OptionsVBoxContainer/RadioButtonsVBoxContainer/HBoxContainer2/VBoxContainerRadioButtons/DeleteAllSavesAlwaysCheckBox
onready var activateDebugScreenRadiobutton = $MainMarginContainer/MarginContainer/ContentVBoxContainer/MenuVBoxContainer/OptionsVBoxContainer/RadioButtonsVBoxContainer/HBoxContainer2/VBoxContainerRadioButtons/ActivateDebugScreenCheckBox
onready var gameConstsEditorButton = $MainMarginContainer/MarginContainer/ContentVBoxContainer/MenuVBoxContainer/OptionsVBoxContainer/GameConstsEditorButton

var gameConstsEditorMenu = load("res://UI/GameConstsEditor/GameConstsEditor.tscn")

func _ready():
	quitButton.connect("pressed", self, "on_quit_pressed") 
	deleteAllSavesButton.connect("pressed", self, "on_save_delete_pressed") 
	deleteAllSavesByDefaultRadiobutton.connect("pressed", self, "on_delete_all_saves_by_default_radiobutton_checked")
	deleteSettingsDataButton.connect("pressed", self, "on_delete_settings_data_pressed")
	activateDebugScreenRadiobutton.connect("pressed", self, "on_debug_screen_radiobutton_pressed")
	resetGameConstantsButton.connect("pressed", self, "on_reset_game_constants_pressed")
	
	gameConstsEditorButton.connect("pressed", self, "on_special_options_pressed") 
	
	var is_game_loaded = Global.is_game_loaded
	resetGameConstantsButton.disabled = !is_game_loaded
	#gameConstsEditorButton.disabled = !is_game_loaded
	
	setup_ui()

func _unhandled_input(event):
	if event.is_action_pressed("pause_menu") and mainMarginContainer.visible:
		on_quit_pressed()

func setup_ui():
	deleteSettingsDataButton.disabled = !SettingsManager.has_settings_file()
	deleteAllSavesButton.disabled = !FileManager.has_any_save_file()
	deleteAllSavesByDefaultRadiobutton.pressed = SettingsManager.settings.should_delete_all_saves_on_start_session
	activateDebugScreenRadiobutton.pressed = SettingsManager.settings.is_debug_screen_active

func on_quit_pressed():
	queue_free()
	emit_signal("back_pressed")

func on_save_delete_pressed():
	FileManager.delete_save()
	setup_ui()

func on_delete_all_saves_by_default_radiobutton_checked():
	SettingsManager.update_should_delete_all_saves_on_start_session_option()
	setup_ui()
	
func on_delete_settings_data_pressed():
	SettingsManager.delete_settings_save()
	setup_ui()

func on_debug_screen_radiobutton_pressed():
	SettingsManager.update_debug_screen_option()
	EventBus.debug_screen_visibility_updated()

func on_special_options_pressed():
	var gameConstsEditorMenuInstance = gameConstsEditorMenu.instance()
	get_tree().root.add_child(gameConstsEditorMenuInstance)
	gameConstsEditorMenuInstance.connect("back_pressed", self, "on_options_back_pressed")
	mainMarginContainer.visible = false

func on_options_back_pressed():
	mainMarginContainer.visible = true

func on_reset_game_constants_pressed():
	GameEventConstants.set_default_constants()
	FileManager.save_game()
