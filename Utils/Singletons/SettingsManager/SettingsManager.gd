extends Node

var SAVE_DIR = "res://Saves/"
var game_settings_save_name = "Game_settings.tres"
var save_path = SAVE_DIR + game_settings_save_name

var settings = SettingsResource.new()

func _ready():
	load_settings()

func save_settings():
	var error = ResourceSaver.save(save_path, settings)
	if error != OK:
		print("Setting save Error")
	else:
		print("Game settings saved")
		
func load_settings():
	var file = File.new()
	if file.file_exists(save_path):
		settings = load(save_path)
	
################### Update properties functions ##################

func update_should_delete_all_saves_on_start_session_option():
	settings.should_delete_all_saves_on_start_session = !settings.should_delete_all_saves_on_start_session
	save_settings()
	
func delete_settings_save():
	var dir = Directory.new()
	dir.remove(save_path)
	settings = SettingsResource.new()
