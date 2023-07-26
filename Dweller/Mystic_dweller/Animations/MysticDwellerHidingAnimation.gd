extends Node2D

var appearParticles = preload("res://WorldObjects/Technical/MysticDwellerAppearParticles/MysticDwellerAppearParticles.tscn")

func spawn_appear_particles():
	var particles = appearParticles.instance()
	get_parent().add_child(particles)
	particles.scale = Vector2.ONE * scale
	particles.global_position = global_position
