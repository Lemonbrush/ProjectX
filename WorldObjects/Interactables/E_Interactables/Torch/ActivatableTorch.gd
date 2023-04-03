extends Node2D

export var is_torch_activated = false

onready var interaction_popup = $InteractionPopup
onready var interaction_conteroller = $InteractionController
onready var fire_particles = $FireParticles
onready var light_source = $LightSource
onready var ignite_particles = $IgniteParticles
onready var ignite_light_particles = $IgniteLightParticles

func _ready():
	fire_particles.emitting = is_torch_activated
	light_source.strength = is_torch_activated
	
	var _on_approach_connection = interaction_conteroller.connect("on_approach", self, "on_approach")
	var _on_interact_connection = interaction_conteroller.connect("on_interact", self, "on_interact") 
	var _on_leave_connection = interaction_conteroller.connect("on_leave", self, "on_leave")

func on_approach(_body):
	if !is_torch_activated:
		interaction_popup.show()

func on_interact(_body):
	if !is_torch_activated:
		activate()

func activate():
	ignite_particles.emitting = true
	fire_particles.emitting = true
	ignite_light_particles.emitting = true
	light_source.strength = true
	is_torch_activated = true
	interaction_popup.hide()

func on_leave():
	interaction_popup.hide()
