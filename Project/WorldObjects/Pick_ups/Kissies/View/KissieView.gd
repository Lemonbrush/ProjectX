extends Node2D

signal did_finish_animation()

onready var pickup_animation = $PickupAnimationPlayer

func pickup():
	pickup_animation.play("Pickup")

func emit_did_finish_animation():
	emit_signal("did_finish_animation")
