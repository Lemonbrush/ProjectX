extends Node2D

onready var heart_motion_animation_player = $Heart/MotionAnimationPlayer
onready var shine_particles = $Heart/ShineParticles2D
onready var dialog_controller = $DialogController

func _ready():
	configure_scene()

func start_spirit_floating_animation():
	heart_motion_animation_player.play("Animate")
	shine_particles.emitting = true
	set_scene_visible(true)

func configure_scene():
	var should_be_visible_constant = GameEventConstants.get_constant("lover_dweller_said_thank_you")
	if should_be_visible_constant == null:
		return
	set_scene_visible(should_be_visible_constant)

func set_scene_visible(is_visible):
	dialog_controller.set_player_interaction(is_visible)
	visible = is_visible
	shine_particles.emitting = is_visible
