extends Node2D

onready var animationPlayer = $AnimationPlayer

func play_dropped_animation():
	animationPlayer.play("Dropped")
