extends Node2D

onready var animationPlayer = $AnimationPlayer

func play_show_animation():
	animationPlayer.play("Show")
