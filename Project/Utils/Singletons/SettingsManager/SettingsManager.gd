extends Node

var SAVE_DIR = "user://Saves"
var game_settings_save_name = "Game_settings.tres"
var save_path = SAVE_DIR + game_settings_save_name

var settings = SettingsResource.new()

func _ready():
	load_settings()

func save_settings():
	var dir = Directory.new()
	if !dir.dir_exists(SAVE_DIR):
		dir.make_dir_recursive(SAVE_DIR)
		
	var error = ResourceSaver.save(save_path, settings)
	if error != OK:
		print("Setting save Error")
	else:
		print("Game settings saved")
		
func load_settings():
	TranslationServer.set_locale("ru")
	
	if has_settings_file():
		settings = load(save_path)

func has_settings_file():
	var file = File.new()
	return file.file_exists(save_path)
	
################### Update properties functions ##################

func update_cursor_active_option():
	settings.is_cursor_active = !settings.is_cursor_active
	save_settings()

func update_debug_screen_option():
	settings.is_debug_screen_active = !settings.is_debug_screen_active
	save_settings()
	
func update_should_delete_all_saves_on_start_session_option():
	settings.should_delete_all_saves_on_start_session = !settings.should_delete_all_saves_on_start_session
	save_settings()
	
func delete_settings_save():
	var dir = Directory.new()
	dir.remove(save_path)
	settings = SettingsResource.new()