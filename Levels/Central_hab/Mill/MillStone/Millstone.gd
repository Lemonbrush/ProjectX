extends Node2D

onready var animationPlayer = $AnimationPlayer

func _ready():
	if GameEventConstants.constants.has("is_mill_gear_clanged") &&  GameEventConstants.constants["is_mill_gear_activated"]:
		animationPlayer.play("MillActive")
	else:
		animationPlayer.play("MillStale")

func show_activate_animation():
	animationPlayer.play("Activate")
