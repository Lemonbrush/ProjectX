extends BaseLevel

onready var loversParticles = $Middle_world_objects/LoversHeartsParticles

func _ready():
	var _connection = EventBus.connect("show_lighthouse_key", self, "show_lighthouse_key")
	var _lovers_connection = EventBus.connect("show_lovers_cut_scene", self, "show_lovers_cut_scene")
	configure_lovers_particles()

func show_lighthouse_key():
	animationPlayer.queue("show_lighthouse_key_cut_scene")

func show_lovers_cut_scene():
	loversParticles.emitting = true

func configure_lovers_particles():
	var lovers_particles_emitting = GameEventConstants.get_constant("lover_dweller_said_thank_you")
	if lovers_particles_emitting != null:
		loversParticles.emitting = lovers_particles_emitting
