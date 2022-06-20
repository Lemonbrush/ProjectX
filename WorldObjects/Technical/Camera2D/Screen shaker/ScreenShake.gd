extends Node

const TRANS = Tween.TRANS_SINE
const EASE = Tween.EASE_IN_OUT

onready var shakeTween = $ShakeTween
onready var frequencyTimer = $Frequency
onready var durationTimer = $Duration

onready var camera = get_parent()

var shakeAmplitude = 0

func _ready():
	frequencyTimer.connect("timeout", self, "_on_frequency_timeout")
	durationTimer.connect("timeout", self, "_on_duration_timeout")
	
	var _start_shake_connect = EventBus.connect("start_shake_screen", self, "start")
	var _stop_shake_connect =EventBus.connect("stop_shake_screen", self, "stop")

func start(duration = 0.2, frequency = 16, amplitude = 2, infinity = true):
	shakeAmplitude = amplitude
	
	durationTimer.wait_time = duration
	frequencyTimer.wait_time = 1 / float(frequency)
	if !infinity:
		durationTimer.start()
	frequencyTimer.start()
	
	_new_shake()

func stop():
	_reset()
	frequencyTimer.stop()

func _new_shake():
	var rand = Vector2()
	rand.x = rand_range(-shakeAmplitude, shakeAmplitude)
	rand.y = rand_range(-shakeAmplitude, shakeAmplitude)
	
	shakeTween.interpolate_property(camera, "offset", camera.offset, rand, frequencyTimer.wait_time, TRANS, EASE)
	shakeTween.start()
	
func _reset():
	shakeTween.interpolate_property(camera, "offset", camera.offset, Vector2(), frequencyTimer.wait_time, TRANS, EASE)
	shakeTween.start()

func _on_frequency_timeout():
	_new_shake()

func _on_duration_timeout():
	stop()
	 
