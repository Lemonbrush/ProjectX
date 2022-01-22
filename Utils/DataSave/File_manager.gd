extends Node

var SAVE_DIR = "res://Saves/"
var save_path = SAVE_DIR

var current_level = ""

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

func load_game():
	var save_game = File.new()
	print("trying to load ", save_path + current_level + ".tres")
	if not save_game.file_exists(save_path + current_level + ".tres"):
		return
	
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	
	for i in save_nodes:
		i.queue_free()
	
	save_game.open(save_path + current_level + ".tres", File.READ)
	while save_game.get_position() < save_game.get_len():
		var node_data = parse_json(save_game.get_line())
		
		var new_object = load(node_data["filename"]).instance()
		get_node(node_data["parent"]).add_child(new_object)
		new_object.position = Vector2(node_data["pos_x"], node_data["pos_y"])
		new_object.z_index = node_data["z_index"]
		new_object.add_to_group("Persist")
		
		if new_object.has_method("load_state"):
			new_object.load_state(node_data["state"])
		
		if "nextDoorName" in node_data:
			new_object.nextDoorName = node_data["nextDoorName"]
		
		for i in node_data.keys():
			if i == "filename" or i == "parent" or i == "pos_x" or i == "pos_y":
				continue
			new_object.set(i, node_data[i])
	save_game.close()

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
