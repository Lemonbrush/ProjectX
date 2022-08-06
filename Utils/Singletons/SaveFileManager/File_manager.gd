extends Node

var save_file_resource = Save_file_resource.new()

var SAVE_DIR = "user://Saves"
var game_save_name = "Game_save.tres"
var save_path = SAVE_DIR + game_save_name

var current_level = ""

var player_position_by_door = null

func save_game():
	var dir = Directory.new()
	if !dir.dir_exists(SAVE_DIR):
		dir.make_dir_recursive(SAVE_DIR)
	
	# saving logic
	
	var currentScene = get_tree().get_current_scene()
	
	# we have to make all subNodes to be in the root node in order to let them be packed
	for child in currentScene.get_children():
		if child.has_method("set_owner"):
			child.set_owner(currentScene)
	
	var packedScene = PackedScene.new()
	packedScene.pack(currentScene)
	var lastVisitedSceneName = get_tree().get_current_scene().get_name() 
	save_file_resource.lastVisitedSceneName = lastVisitedSceneName
	save_file_resource.savedLevelScenes[lastVisitedSceneName] = packedScene
	save_file_resource.playerPosition = get_tree().get_current_scene().find_node("Player").get_global_position()
	if GameEventConstants.constants:
		save_file_resource.gameLogicVariables = GameEventConstants.constants
	
	var error = ResourceSaver.save(save_path, save_file_resource)
	if error != OK:
		print("Save Error")
	else:
		print("Game saved")
		
func load_game():
	Global.is_game_loaded = true
	
	if has_any_save_file() && !SettingsManager.settings.should_delete_all_saves_on_start_session:
		save_file_resource = load(save_path)
		var lastVisitedSceneName = save_file_resource.lastVisitedSceneName
		var lastVisitedScene = save_file_resource.savedLevelScenes[lastVisitedSceneName]
		GameEventConstants.constants = save_file_resource.gameLogicVariables
		var _changedScene = get_tree().change_scene_to(lastVisitedScene)
	else:
		delete_save()
		var _scene = get_tree().change_scene("res://Levels/Start_gate_location/Start_gate_location.tscn")

func delete_save():
	var dir = Directory.new()
	dir.remove(save_path)
	GameEventConstants.set_default_constants()
	
func has_any_save_file():
	var file = File.new()
	return file.file_exists(save_path)

###############

func get_project_version():
	var version_file_path = 'res://VERSION'
	var version_file = File.new()
	var project_version
	
	var directory = Directory.new()
	if directory.file_exists(version_file_path):
		version_file.open(version_file_path, File.READ)
		project_version = version_file.get_line()
		version_file.close()
	else:
		project_version = "version file not found"
	
	return project_version
