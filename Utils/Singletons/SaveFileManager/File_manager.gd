extends Node

var save_file_resource

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
		save_file_resource = Save_file_resource.new()
		var _scene = get_tree().change_scene("res://Levels/Start_gate_location/Start_gate_location.tscn")
	
func configure_new_object(new_object, node_data):
	if "objectType" in node_data:
		new_object.position = Vector2(node_data["pos_x"], node_data["pos_y"])
		new_object.z_index = node_data["z_index"]
		
		match node_data.objectType:
			"Destructable":
				new_object.add_to_group("Persist")
			"Player":
				new_object.add_to_group("Persist")
				new_object.add_to_group("player")
				
				if player_position_by_door:
					new_object.global_position = player_position_by_door
					player_position_by_door = null
			"Door":
				new_object.add_to_group("Door")
				new_object.nextDoorName = node_data["nextDoorName"]
				new_object.nextScenePath = node_data["nextScenePath"]
				new_object.state = node_data["state"]
				new_object.load_state(node_data["state"])
				new_object.add_to_group("Persist")
	
	for i in node_data.keys():
		if i == "filename" or i == "parent" or i == "pos_x" or i == "pos_y":
			continue
		new_object.set(i, node_data[i])

######### Page Persistence ############

func save_page(page_num):
	var saved_pages = get_pages()
	
	var dir = Directory.new()
	if !dir.dir_exists(SAVE_DIR):
		dir.make_dir_recursive(SAVE_DIR)
	
	var file = File.new()
	var error = file.open(save_path, File.WRITE)
	if error == OK:
		print(saved_pages)
		
		var isUnique = true
		for page in saved_pages.unlocked_pages:
			if page == page_num:
				isUnique = false
		
		if isUnique:
			saved_pages.unlocked_pages.append(page_num)
		file.store_var(saved_pages)
		file.close()
	
func get_pages():
	var file = File.new()
	if file.file_exists(save_path):
		var error = file.open(save_path, File.READ)
		if error == OK:
			var player_data = file.get_var()
			file.close()
			return player_data
	
	var empty_data = {
		"unlocked_pages" : []
	}
	
	return empty_data
