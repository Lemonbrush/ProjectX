extends Node2D

signal cork_destroyed_on_water_tower(water_tawer_number)

export(int) var water_tower_number

onready var animationPlayer = $AnimationPlayer
onready var cork = $Cork

func _ready():
	cork.connect("cork_destroyed", self, "cork_destroyed") 
	
func cork_destroyed():
	animationPlayer.play("Activate")
	emit_signal("cork_destroyed_on_water_tower", water_tower_number)
