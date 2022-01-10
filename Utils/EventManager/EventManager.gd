extends Node
class_name EventManager

onready var collectable_page = $Collectables/Page/Area2D

func _ready():
	#collectable_page.connect("body_entered", self, "on_page_collected")
	pass
	
func on_page_collected():
	print("page collected !!!")
