extends Node2D

signal animationFinished

func finish_animation():
	emit_signal("animationFinished")
	queue_free()
