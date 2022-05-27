extends Node2D

signal page_collected

export(int) var page_number

onready var file_manager		= $"/root/FileManager"
onready var area2d			= $Area2D

func _ready():
	area2d.connect("body_entered", self, "on_area_entered")

func on_area_entered(body):
	if body.has_method("start_item_pickup_animation"):
		body.start_item_pickup_animation()
	emit_signal("page_collected")
	queue_free()
	
	FileManager.save_game()
