extends Node2D

onready var animationPlayer = $AnimationPlayer

func play_animation(animation_name):
	animationPlayer.play(animation_name)
