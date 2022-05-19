extends Node2D

onready var animationPlayer		= $AnimationPlayer
onready var page_collectable 	= $Collectables/Page

func _ready():
	page_collectable.connect("page_collected", self, "on_page_collected") 
	
func on_page_collected():
	animationPlayer.play("Gate_opening_cut_scene")
