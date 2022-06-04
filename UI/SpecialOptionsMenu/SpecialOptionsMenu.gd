extends CanvasLayer
signal back_pressed

onready var quitButton = $MarginContainer2/CenterContainer/VBoxContainer/ExitButton
onready var deleteAllSavesButton = $MarginContainer2/CenterContainer/VBoxContainer/ButtonsVBoxContainer/DeleteAllSavesButton
onready var deleteAllSavesByDefaultRadiobutton = $MarginContainer2/CenterContainer/VBoxContainer/RadioButtonsVBoxContainer/HBoxContainer/CheckBox
onready var deleteSettingsDataButton = $MarginContainer2/CenterContainer/VBoxContainer/ButtonsVBoxContainer/DeleteSystemDataButton

func _ready():
	quitButton.connect("pressed", self, "on_quit_pressed") 
	deleteAllSavesButton.connect("pressed", self, "on_save_delete_pressed") 
	deleteAllSavesByDefaultRadiobutton.connect("pressed", self, "on_delete_all_saves_by_default_radiobutton_checked")
	deleteSettingsDataButton.connect("pressed", self, "on_delete_settings_data_pressed")
	
	setup_ui()

func setup_ui():
	deleteAllSavesByDefaultRadiobutton.pressed = SettingsManager.settings.should_delete_all_saves_on_start_session

func on_quit_pressed():
	queue_free()
	emit_signal("back_pressed")

func on_save_delete_pressed():
	deleteAllSavesButton.disabled = true
	FileManager.delete_save()

func on_delete_all_saves_by_default_radiobutton_checked():
	SettingsManager.update_should_delete_all_saves_on_start_session_option()
	
func on_delete_settings_data_pressed():
	deleteSettingsDataButton.disabled = true
	SettingsManager.delete_settings_save()
	setup_ui()
