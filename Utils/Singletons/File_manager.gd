extends Node

var SAVE_DIR = "res://Saves/"
var save_path = SAVE_DIR

var current_level = ""

var player_position_by_door = null

func save_game():
	var dir = Directory.new()
	if !dir.dir_exists(SAVE_DIR):
		dir.make_dir_recursive(SAVE_DIR)
	
	var file = File.new()
	var error = file.open(save_path + current_level + ".tres", File.WRITE)
	
	if error == OK:
		var save_nodes = get_tree().get_nodes_in_group("Persist")
		
		for node in save_nodes:
			if node.filename.empty():
				print("Persistent node '%s' is not an instanced scene, skipped" % node.name)
				continue
			
			if !node.has_method("save"):
				print("Persistent node '%s' is missing a save() function, skipped" % node.name)
				continue
			
			var node_data = node.call("save")
		
			file.store_line(to_json(node_data))
	file.close()

func load_game(playerPosition):
	var save_game = File.new()
	#print("trying to load ", save_path + current_level + ".tres")
	if not save_game.file_exists(save_path + current_level + ".tres"):
		return
	
	player_position_by_door = playerPosition
	
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	
	for i in save_nodes:
		i.queue_free()
	
	save_game.open(save_path + current_level + ".tres", File.READ)
	while save_game.get_position() < save_game.get_len():
		var node_data = parse_json(save_game.get_line())
		var new_object = load(node_data["filename"]).instance()
		get_node(node_data["parent"]).add_child(new_object)
		
		configure_new_object(new_object, node_data)

	save_game.close()
	
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