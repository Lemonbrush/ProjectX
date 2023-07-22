extends Node2D

export var CHAR_READ_RATE = 0.02
export var text = ""
export var showing_time = 5

onready var floatingTween = $FloatingTween
onready var textTypingTween = $TextTypingTween
onready var appearTween = $AppearTween
onready var label = $Label
onready var timer = $Timer

var float_animation_direction_up = false

func _ready():
	modulate.a = 0.0
	timer.wait_time = showing_time
	
	floatingTween.connect("tween_completed", self, "floating_tween_finished")
	timer.connect("timeout", self, "hide")
	start_floating_animation()

func hide():
	if modulate.a != 0.0:
		start_hide_animation()

func show():
	if text == null or text == "":
		label.visible = false
		return
	
	textTypingTween.interpolate_property(label, "percent_visible", 0.0, 1.0, len(text) * CHAR_READ_RATE, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	textTypingTween.start()
	
	label.percent_visible = 0
	label.visible = true
	label.text = text
	
	timer.start()
	start_show_animation()

#### Animation logic

func start_show_animation():
	appearTween.stop(self)
	appearTween.interpolate_property(self, 'modulate:a', get_modulate().a, 1.0, 0.25, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0)
	appearTween.interpolate_property(self, 'position:y', self.position.y, 0.0, 0.25, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0)
	appearTween.start()

func start_hide_animation():
	appearTween.stop(self)
	appearTween.interpolate_property(self, 'modulate:a', get_modulate().a, 0.0, 0.25, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0)
	appearTween.interpolate_property(self, 'position:y', self.position.y, -10, 0.25, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0)
	appearTween.start()

#### Floating animation

func start_floating_animation():
	var new_y_position = 0
	if float_animation_direction_up:
		new_y_position = 3 
	float_animation_direction_up = !float_animation_direction_up

	floatingTween.stop(self)
	floatingTween.interpolate_property(self, 'position:y', self.position.y, new_y_position, 2, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT, 0)
	floatingTween.start()
	

func floating_tween_finished(_arg1, _arg2):
	start_floating_animation()
