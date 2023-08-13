extends Node2D

signal did_press_button_with_text(text)

onready var label = $PanelContainer/MarginContainer/VBoxContainer/Label
onready var buttonHint = $PanelContainer/ButtonHint
onready var buttonsContainer = $PanelContainer/MarginContainer/VBoxContainer/ButtonsContainer

var animated_button_scene_path = preload("res://Project/UI/Animated_dialog_button/AnimatedDialogButton.tscn")

# Lifecycle

func _ready():
	buttonHint.set_hint_action("Interaction")
	hide_button_hint()

func button_option_pressed(button_text):
	emit_signal("did_press_button_with_text", button_text)

# Functions

func set_label_text_percent_visible(new_percent):
	label.percent_visible = new_percent

func set_label_text(new_text):
	label.text = new_text
	
	if label.text == "":
		hide_label()
	else:
		show_label()

func get_label_text():
	return label.text

func setup_button_options(button_options):
	buttonsContainer.visible = true
	remove_all_buttons()
	setup_buttons(button_options)
	grab_button_focuse_if_needed()

func remove_and_hide_buttons():
	remove_all_buttons()
	buttonsContainer.visible = false

func hide_label():
	label.visible = false

func show_label():
	label.visible = true

func show_button_hint():
	buttonHint.visible = true

func hide_button_hint():
	buttonHint.visible = false

# Private functions

func setup_buttons(button_options):
	for button_option in button_options:
		var button = animated_button_scene_path.instance()
		button.set_text(button_option["text"])
		buttonsContainer.add_child(button)
		button.connect("pressed", self, "button_option_pressed", [button.text])

func remove_all_buttons():
	for child in buttonsContainer.get_children():
		buttonsContainer.remove_child(child)

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
