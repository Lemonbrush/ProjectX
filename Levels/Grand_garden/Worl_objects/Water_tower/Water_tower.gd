extends Node2D

onready var animationPlayer = $AnimationPlayer
onready var cork = $Cork

func _ready():
	cork.connect("cork_destroyed", self, "cork_destroyed") 
	
func cork_destroyed():
	animationPlayer.play("Activate")
