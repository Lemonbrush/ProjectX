tool
extends Control

signal did_press_rebind_key(key_action)

export (String) var button_text = ""
export (String) var key_action_title = ""

onready var button = $HBoxContainer/AnimatedDialogButton
onready var button_hint = $HBoxContainer/ButtonHint

func _ready():
	_setup_ui()
	button.connect("pressed_and_resolved", self, "did_press_button")

func did_press_button():
	emit_signal("did_press_rebind_key", key_action_title)

func _setup_ui():
	button_hint.set_hint_action(key_action_title)
	button.text = button_text
