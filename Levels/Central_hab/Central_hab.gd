extends BaseLevel

onready var loversParticles = $WorldObjects/LoversHeartsParticles

func _ready():
	var _connection = EventBus.connect("show_lighthouse_key", self, "show_lighthouse_key")
	var _lovers_connection = EventBus.connect("show_lovers_cut_scene", self, "show_lovers_cut_scene")
	
	var lovers_particles_emitting = GameEventConstants.get_constant("lover_dweller_said_thank_you")
	if lovers_particles_emitting:
		loversParticles.emitting = lovers_particles_emitting

func show_lighthouse_key():
	animationPlayer.queue("show_lighthouse_key_cut_scene")

func show_lovers_cut_scene():
	loversParticles.emitting = true
