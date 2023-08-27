tool

extends Control

export (String) var button_text = ""

onready var button = $HBoxContainer/AnimatedDialogButton

func _ready():
	button.text = button_text
