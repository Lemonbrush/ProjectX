extends Node2D

signal page_collected

export(int) var page_number

onready var file_manager		= $"/root/FileManager"
onready var area2d			= $Area2D

func _ready():
	area2d.connect("body_entered", self, "on_area_entered")

func on_area_entered(_body):
	#file_manager.save_page(page_number)
	emit_signal("page_collected")
	queue_free()
	
	FileManager.save_game()
	
func save():
	var save_dict = {
		"objectType" : "Destructable",
		"filename" : get_filename(),
		"parent" : get_parent().get_path(),
		"pos_x" : position.x, 
		"pos_y" : position.y,
		"z_index" : z_index
	}
	return save_dict
