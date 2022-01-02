extends Node

var SAVE_DIR = "res://saves/"
var save_path = SAVE_DIR + "save.tres"

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
	
	print("File saved")
	
func get_pages():
	var file = File.new()
	if file.file_exists(save_path):
		var error = file.open(save_path, File.READ)
		if error == OK:
			var player_data = file.get_var()
			file.close()
			return player_data
			print("File read - ", player_data.value)
	
	var empty_data = {
		"unlocked_pages" : []
	}
	
	return empty_data
