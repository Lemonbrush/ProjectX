extends Node2D

onready var loversParticles = $LoversHeartsParticles
onready var animationPlayer = $AnimationPlayer

func _ready():
	var _lovers_connection = EventBus.connect("show_lovers_cut_scene", self, "show_lovers_cut_scene")
	configure_lovers_particles()

func configure_lovers_particles():
	var lovers_particles_emitting = GameEventConstants.get_constant("lover_dweller_said_thank_you")
	if lovers_particles_emitting != null:
		loversParticles.emitting = lovers_particles_emitting
	
func show_lovers_cut_scene():
	loversParticles.emitting = true
	animationPlayer.play("First_kiss_spirit_appear")
