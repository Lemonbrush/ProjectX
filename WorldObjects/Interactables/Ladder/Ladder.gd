extends Node2D

onready var animationPlayer = $AnimationPlayer

func _ready():
	if GameEventConstants.constants.has("mill_ladder_placed") && GameEventConstants.constants["mill_ladder_placed"]:
		animationPlayer.play("idle_shown")
	else:
		animationPlayer.play("idle")

func show_appear_animation():
	animationPlayer.play("Appear") 
