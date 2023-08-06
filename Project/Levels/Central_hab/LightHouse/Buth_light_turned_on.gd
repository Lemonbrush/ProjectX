extends Node2D

onready var particles = $Particles2D

func set_active(is_active):
	visible = is_active
	particles.emitting = is_active
