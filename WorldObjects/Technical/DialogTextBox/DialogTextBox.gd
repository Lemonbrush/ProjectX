extends Node2D

signal pressed_button_number(button_text)

export var CHAR_READ_RATE = 0.02

onready var textTween = $TextTween
onready var appearanceTween = $AppearanceTween
onready var floatTween  = $FloatTween
onready var label = $MarginNode/PanelContainer/MarginContainer/VBoxContainer/Label
onready var marginNode = $MarginNode
onready var buttonHint = $MarginNode/PanelContainer/ButtonHint
onready var buttonsContainer = $MarginNode/PanelContainer/MarginContainer/VBoxContainer/ButtonsContainer

var animated_button_scene_path = preload("res://UI/Animated_dialog_button/AnimatedDialogButton.tscn")
var float_animation_direction_up = false

func _ready():
	buttonHint.set_hint_action("Interaction")
	buttonHint.modulate.a = 0.0
	modulate.a = 0.0
	
	floatTween.connect("tween_completed", self, "floating_tween_finished")
	start_floating_animation()

func show_text(text, button_options = null):
	remove_buttons()
	buttonsContainer.visible = button_options != null

	if button_options:
		setup_buttons(button_options)
		grab_button_focuse_if_needed()
		
	buttonHint.modulate.a = 0.0
	add_text(text)
	start_show_animation()

func hide():
	if modulate.a != 0.0:
		start_hide_animation()

func set_button_hint_visibility(visible):
	buttonHint.visible = visible

#### Actions

func button_option_pressed(button_text):
	emit_signal("pressed_button_number", button_text)

#### Helper functions

func remove_buttons():
	for n in buttonsContainer.get_children():
		buttonsContainer.remove_child(n)

func setup_buttons(button_options):
	for button_option in button_options:
		var button = animated_button_scene_path.instance()
		button.set_text(button_option["text"])
		buttonsContainer.add_child(button)
		button.connect("pressed", self, "button_option_pressed", [button.text])

func grab_button_focuse_if_needed():
	if buttonsContainer.get_children().size() < 1:
		return
	var button = buttonsContainer.get_children()[0]
	if button == null:
		return
	if  buttonsContainer.get_children().size() == 1:
		button.grab_focus()
		return
	
	if button.has_method("grab_focus_without_animation"):
		button.grab_focus_without_animation()
	
func add_text(next_text):
	if next_text == null:
		label.visible = false
		return
	
	textTween.interpolate_property(label, "percent_visible", 0.0, 1.0, len(next_text) * CHAR_READ_RATE, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	textTween.start()
	
	label.percent_visible = 0
	label.visible = true
	label.text = next_text 

#### Animation logic

func start_show_animation():
	appearanceTween.stop(self)
	appearanceTween.interpolate_property(self, 'modulate:a', get_modulate().a, 1.0, 0.25, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0)
	appearanceTween.interpolate_property(buttonHint, 'modulate:a', buttonHint.get_modulate().a, 1.0, 0.25, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0.5)
	appearanceTween.interpolate_property(marginNode, 'position:y', marginNode.position.y, 0.0, 0.25, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0)
	appearanceTween.start()

func start_hide_animation():
	appearanceTween.stop(self)
	appearanceTween.interpolate_property(self, 'modulate:a', get_modulate().a, 0.0, 0.25, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0)
	appearanceTween.interpolate_property(marginNode, 'position:y', marginNode.position.y, -10, 0.25, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0)
	appearanceTween.start()

#### Floating animation

func start_floating_animation():
	var new_y_position = 0
	if float_animation_direction_up:
		new_y_position = 3 
	float_animation_direction_up = !float_animation_direction_up

	floatTween.stop(self)
	floatTween.interpolate_property(marginNode, 'position:y', marginNode.position.y, new_y_position, 2, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT, 0)
	floatTween.start()
	

func floating_tween_finished(_arg1, _arg2):
	start_floating_animation()
