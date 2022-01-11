extends Node2D

func _ready():
	pass
		
func on_open_gates_call():
	$AnimationPlayer.play("Open")
