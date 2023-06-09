extends Node2D

signal player_did_enter_elevator

export (bool) var did_activate_platform = false
export (bool) var did_elevate_to_sky_island = false

onready var animationPlayer = $AnimationPlayer
onready var area2d = $PlatformDetectionArea
onready var interactionController = $InteractionEmitterObject

func _ready():
	var _connection = area2d.connect("body_entered", self, "on_area_enter")
	var _interaction_connection = interactionController.connect("interacted_with_arg", self, "player_did_enter_elevator")
	interactionController.set_interaction_enabled(did_activate_platform)

func on_area_enter(_body):
	if !did_activate_platform or did_elevate_to_sky_island:
		animationPlayer.play("Lift_down")
		did_elevate_to_sky_island = false
		did_activate_platform = true

func player_did_enter_elevator(_arg):
	interactionController.set_interaction_enabled(false)
	emit_signal("player_did_enter_elevator")

func enable_platform_interaction():
	interactionController.set_interaction_enabled(true)

func did_finish_elevation_to_sky_island():
	enable_platform_interaction()
	did_elevate_to_sky_island = true
