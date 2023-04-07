extends CanvasLayer

var wide_torch_fire = preload("res://Resources/Particles/Fire/Wide_torch_fire_process_material.tres")
var crush_dust = preload("res://Resources/Particles/Crush_particles/Crush_dust/CrushDustProcessMaterial.tres")
var crush_shine = preload("res://Resources/Particles/Crush_particles/Crush_shine/CrushShineProcessMaterial.tres")
var crush_vase = preload("res://Resources/Particles/Crush_particles/Vase_crush/VaseCrushProcessMaterial.tres")
var stars = preload("res://Resources/Particles/Background_particles/Stars/Stars_process_material.tres")

var materials = [
	wide_torch_fire,
	crush_dust,
	crush_shine,
	crush_vase,
	stars
	]

func _ready():
	for material in materials:
		var particle_instance = Particles2D.new()
		particle_instance.set_process_material(material)
		particle_instance.set_one_shot(true)
		particle_instance.set_modulate(Color(1,1,1,0))
		particle_instance.set_emitting(true)
		add_child(particle_instance)
