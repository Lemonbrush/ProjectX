extends Node2D

onready var animationPlayer = $AnimationPlayer

func play_hiding_animation():
	animationPlayer.play("Hiding")
