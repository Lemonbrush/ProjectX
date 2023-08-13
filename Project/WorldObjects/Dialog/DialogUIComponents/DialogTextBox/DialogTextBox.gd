extends Node2D

signal did_press_button_with_text(text)

onready var textBoxContainer = $TextBoxContainer
onready var floatingContainer = $FloatingContainer
onready var appearAnimator = $AppearAnimator

#### Lifecycle

func _ready():
	appearAnimator.instant_hide()
	floatingContainer.start()
	textBoxContainer.connect("did_press_button_with_text", self, "did_press_button_with_text")

func did_press_button_with_text(button_text):
	emit_signal("did_press_button_with_text", button_text)

# Functions

func show_if_needed():
	appearAnimator.show_if_needed()

func set_label_text(new_text):
	textBoxContainer.set_label_text(new_text)

func get_label_text():
	return textBoxContainer.get_label_text()

func show_button_options(button_options):
	textBoxContainer.setup_button_options(button_options)

func hide_buttons():
	textBoxContainer.remove_and_hide_buttons()

func show_button_hint():
	textBoxContainer.show_button_hint()

func hide_button_hint():
	textBoxContainer.hide_button_hint()

func show():
	appearAnimator.show()

func hide():
	appearAnimator.hide()

func instant_hide():
	appearAnimator.instant_hide()
