extends Node2D

signal pressed_button_number(button_number)

export var CHAR_READ_RATE = 0.02

onready var textTween = $TextTween
onready var appearanceTween = $AppearanceTween
onready var label = $MarginNode/PanelContainer/MarginContainer/VBoxContainer/Label
onready var marginNode = $MarginNode
onready var buttonHint = $MarginNode/PanelContainer/ButtonHint
onready var buttonsContainer = $MarginNode/PanelContainer/MarginContainer/VBoxContainer/ButtonsContainer

func _ready():
	buttonHint.modulate.a = 0.0
	modulate.a = 0.0

func show_text(text, button_options = null):
	remove_buttons()
	buttonsContainer.visible = button_options != null
	if button_options:
		setup_buttons(button_options)
		
	buttonHint.modulate.a = 0.0
	add_text(text)
	start_show_animation()

func hide():
	if modulate.a != 0.0:
		start_hide_animation()

#### Helper functions

func remove_buttons():
	for n in buttonsContainer.get_children():
		buttonsContainer.remove_child(n)

func setup_buttons(button_options):
	for button_option in button_options:
		var button = Button.new()
		button.set_text(button_option)
		buttonsContainer.add_child(button)
	
func add_text(next_text):
	label.text = next_text
	textTween.interpolate_property(label, "percent_visible", 0.0, 1.0, len(next_text) * CHAR_READ_RATE, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	textTween.start()

#### Animation logic

func start_show_animation():
	marginNode.position.y = 10
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
