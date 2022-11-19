extends Node2D

onready var flyTween = $Tween
onready var visibilityNotifier = $VisibilityNotifier2D

func _ready():
	var _screen_exited_connection = visibilityNotifier.connect("screen_exited", self, "screen_exited")
	
	var destination_x = position.x + rand_range(-1000, 1000)
	var fly_destination = Vector2(destination_x, position.y - 500)
	scale.x = sign(destination_x)
	
	flyTween.interpolate_property(self, "position", position, fly_destination, 15, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	flyTween.start()

func screen_exited():
	queue_free()
