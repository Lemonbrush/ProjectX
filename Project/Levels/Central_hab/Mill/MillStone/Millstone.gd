extends Node2D

onready var animationPlayer = $AnimationPlayer

func show_activate_animation():
	animationPlayer.play("Activate")
