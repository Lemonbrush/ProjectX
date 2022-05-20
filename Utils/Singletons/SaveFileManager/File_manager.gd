extends Node

var save_file_resource = Save_file_resource.new()

var SAVE_DIR = "res://Saves/"
var game_save_name = "Game_save.tres"
var save_path = SAVE_DIR

var current_level = ""

var player_position_by_door = null

func save_game():
	var dir = Directory.new()
	if !dir.dir_exists(SAVE_DIR):
		dir.make_dir_recursive(SAVE_DIR)
	
	# saving logic
	var packedScene = PackedScene.new()
	packedScene.pack(get_tree().get_current_scene())
	var lastVisitedSceneName = get_tree().get_current_scene().get_name() 
	save_file_resource.lastVisitedSceneName = lastVisitedSceneName
	save_file_resource.savedLevelScenes[lastVisitedSceneName] = packedScene
	save_file_resource.playerPosition = get_tree().get_current_scene().find_node("Player").get_global_position()

	var error = ResourceSaver.save(save_path + game_save_name, save_file_resource)
	if error != OK:
		print("Save Error")
	else:
		print("Game saved")

func load_game():
	var file = File.new()
	if file.file_exists(save_path + game_save_name):
		save_file_resource = load(save_path + game_save_name)
		var lastVisitedSceneName = save_file_resource.lastVisitedSceneName
		var lastVisitedScene = save_file_resource.savedLevelScenes[lastVisitedSceneName]
		var _changedScene = get_tree().change_scene_to(lastVisitedScene)
	else:
		var _scene = get_tree().change_scene("res://Levels/Start_gate_location/Start_gate_location.tscn")

func delete_save():
	var dir = Directory.new()
	dir.remove(save_path + game_save_name)
		
