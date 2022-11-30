extends Node2D

signal lift_guardian_island(lift_up)

export (bool) var lift_up_direction = true

func _ready():
	pass 
	
func lift_guardian_island():
	emit_signal("lift_guardian_island", lift_up_direction)
