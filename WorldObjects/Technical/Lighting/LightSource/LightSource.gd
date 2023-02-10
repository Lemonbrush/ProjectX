extends Position2D
class_name LightSource

export var color := Color("#ffefc4")
export var radius := 64
export(int) var minRadius := 32
export var maxRadius:= 64
export var animating := true
export(float) var animationTime := 5
export (float, 0.0, 1.0, 0.05) var strength := 1.0

onready var tween_values = [minRadius, maxRadius]
onready var tween = $Tween

func _ready():
	if animating:
		_start_tween()
		var _tween_connection = tween.connect("tween_completed", self, "on_tween_completed")

func _start_tween():
	tween.interpolate_property(self, "radius", tween_values[0], tween_values[1], animationTime, Tween.TRANS_LINEAR, Tween.TRANS_LINEAR)
	tween.start()

func on_tween_completed(_object, _key):
	tween_values.invert()
	_start_tween()
