extends AbstractDweller

var appearParticles = preload("res://WorldObjects/Technical/MysticDwellerAppearParticles/MysticDwellerAppearParticles.tscn")

func show_hide_animation():
	animationPlayer.play("Hiding")

func spawn_appear_particles():
	var particles = appearParticles.instance()
	get_parent().add_child(particles)
	particles.scale = Vector2.ONE * scale
	particles.global_position = global_position