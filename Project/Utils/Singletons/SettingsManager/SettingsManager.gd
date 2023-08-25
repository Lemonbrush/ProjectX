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
	if settings == null:
		pass
	
	_change_volume("Music", settings.background_music_volume)
	_change_volume("SFX", settings.sfx_volume)
	

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

func update_background_music_volume(volume):
	settings.background_music_volume = volume
	_change_volume("Music", volume)
	save_settings()

func update_sfx_volume(volume):
	settings.sfx_volume = volume
	_change_volume("SFX", volume)
	save_settings()
	
func delete_settings_save():
	var dir = Directory.new()
	dir.remove(save_path)
	settings = SettingsResource.new()

func _change_volume(bus_name, volume):
	var busIdx = AudioServer.get_bus_index(bus_name)
	var volumeDb = linear2db(volume)
	AudioServer.set_bus_volume_db(busIdx, volumeDb)
