extends Node2D

export(int) var page_number

onready var file_manager		= $"/root/FileManager"
onready var area2d				 = $Area2D

func _ready():
	
	for page in file_manager.get_pages().unlocked_pages:
		print(page, " - ", page_number)
		if int(page) == page_number:
			queue_free()
	
	area2d.connect("body_entered", self, "on_area_entered")

func on_area_entered(_body):
	file_manager.save_page(page_number)
	queue_free()
