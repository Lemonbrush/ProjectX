extends Node2D

onready var flyTween = $Tween
onready var alphaTween = $TweenAlpha
onready var visibilityNotifier = $VisibilityNotifier2D

func _ready():
	var _screen_exited_connection = visibilityNotifier.connect("screen_exited", self, "screen_exited")
	
	var destination_x = position.x + rand_range(-1000, 1000)
	var fly_destination = Vector2(destination_x, position.y - 500)
	scale.x = sign(destination_x)
	
	var animation_time = 15
	
	flyTween.interpolate_property(self, "position", position, fly_destination, animation_time, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	flyTween.start()
	
	alphaTween.interpolate_property(self, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), animation_time, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	alphaTween.start()

func screen_exited():
	queue_free()
