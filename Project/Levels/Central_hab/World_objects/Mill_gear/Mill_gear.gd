extends Node2D

onready var animationPlayer = $AnimationPlayer

func _ready():
	if GameEventConstants.constants.has("is_mill_gear_clanged") &&  GameEventConstants.constants["is_mill_gear_clanged"]:
		animationPlayer.play("Locked")
	else:
		animationPlayer.play("idle")