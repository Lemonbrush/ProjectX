extends CanvasLayer
signal back_pressed

onready var quitButton = $MainMarginContainer/MarginContainer/ContentVBoxContainer/MenuVBoxContainer/ExitButton
onready var deleteAllSavesButton = $MainMarginContainer/MarginContainer/ContentVBoxContainer/MenuVBoxContainer/OptionsVBoxContainer/ButtonsVBoxContainer/DeleteAllSavesButton
onready var deleteAllSavesByDefaultRadiobutton = $MainMarginContainer/MarginContainer/ContentVBoxContainer/MenuVBoxContainer/OptionsVBoxContainer/RadioButtonsVBoxContainer/HBoxContainer/CheckBox
onready var deleteSettingsDataButton = $MainMarginContainer/MarginContainer/ContentVBoxContainer/MenuVBoxContainer/OptionsVBoxContainer/ButtonsVBoxContainer/DeleteSystemDataButton

func _ready():
	quitButton.connect("pressed", self, "on_quit_pressed") 
	deleteAllSavesButton.connect("pressed", self, "on_save_delete_pressed") 
	deleteAllSavesByDefaultRadiobutton.connect("pressed", self, "on_delete_all_saves_by_default_radiobutton_checked")
	deleteSettingsDataButton.connect("pressed", self, "on_delete_settings_data_pressed")
	
	setup_ui()

func setup_ui():
	deleteSettingsDataButton.disabled = !SettingsManager.has_settings_file()
	deleteAllSavesButton.disabled = !FileManager.has_any_save_file()
	deleteAllSavesByDefaultRadiobutton.pressed = SettingsManager.settings.should_delete_all_saves_on_start_session

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
