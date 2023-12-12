extends Node2D

signal set_background_music_volume(newVolume)
signal reset_background_music_volume()

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

func lower_music_volume():
	emit_signal("set_background_music_volume", -20)

func reset_background_music_volume():
	emit_signal("reset_background_music_volume")
