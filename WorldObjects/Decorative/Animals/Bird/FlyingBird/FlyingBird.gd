extends Node2D

onready var flyTween = $Tween
onready var visibilityNotifier = $VisibilityNotifier2D

func _ready():
	var _screen_exited_connection = visibilityNotifier.connect("screen_exited", self, "screen_exited")
	
	var fly_destination = Vector2(position.x + 1000, position.y - 500)
	flyTween.interpolate_property(self, "position", position, fly_destination, 10, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	flyTween.start()

func screen_exited():
	queue_free()
