extends Node2D

export(String) var dialog_id
onready var dialogTextBoxController = $DialogTextBoxController

export(bool) var is_dialog_active = false

func _ready():
	dialogTextBoxController.set_dialog_id(dialog_id)

func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("Interaction") && is_dialog_active:
		traverse_dialog()

func traverse_dialog():
	dialogTextBoxController.on_interact()

func start_dialog():
	is_dialog_active = true
	traverse_dialog()

func finish_dialog():
	is_dialog_active = false
