extends Node2D

onready var animationPlayer = $WeaveAnimationPlayer

func play_dropped_animation():
	animationPlayer.play("Dropped")
