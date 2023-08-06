extends Node2D

onready var heart_motion_animation_player = $FloatingHeart/MotionAnimationPlayer
onready var shine_particles = $FloatingHeart/ShineParticles2D
onready var dialog_controller = $FloatingHeart/DialogController
onready var animationPlayer = $AnimationPlayer

func _ready():
	var _harvest_kiss_connection = EventBus.connect("show_harvest_kiss_spirit_cutscene", self, "show_harvest_kiss_spirit_cutscene")
	configure_scene()

func start_spirit_floating_animation():
	heart_motion_animation_player.play("Animate")
	shine_particles.emitting = true
	set_scene_visible(true)

func configure_scene():
	var did_harvest_constant = GameEventConstants.get_constant("did_harvest_heart_jur_cutscene_played")
	if did_harvest_constant == null:
		return
	
	if did_harvest_constant:
		dialog_controller.set_player_interaction(false)
		visible = false
	else:
		var should_be_visible_constant = GameEventConstants.get_constant("lover_dweller_said_thank_you")
		if should_be_visible_constant == null:
			return
		set_scene_visible(should_be_visible_constant)

func set_scene_visible(is_visible):
	dialog_controller.set_player_interaction(is_visible)
	visible = is_visible
	shine_particles.emitting = is_visible

func show_harvest_kiss_spirit_cutscene():
	dialog_controller.set_player_interaction(false)
	GameEventConstants.set_constant("did_harvest_heart_jur_cutscene_played", true)
	animationPlayer.play("show_harvest_kiss_spirit_cutscene")
