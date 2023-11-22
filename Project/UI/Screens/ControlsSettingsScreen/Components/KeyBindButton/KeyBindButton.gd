tool
extends Control

signal did_press_rebind_key(key_action)
signal did_focus_entered()

export (String) var button_text = ""
export (String) var key_action_title = ""

onready var button = $HBoxContainer/AnimatedDialogButton
onready var button_hints_container = $HBoxContainer/ButtonHintsContainer

var button_hint = preload("res://Project/UI/Components/ButtonHint/ButtonHint.tscn")

func _ready():
	_setup_ui()
	button.connect("pressed_and_resolved", self, "did_press_button")
	button.connect("focus_entered", self, "did_focus_enter")

func did_focus_enter():
	emit_signal("did_focus_entered")

func did_press_button():
	emit_signal("did_press_rebind_key", key_action_title)

func _setup_ui():
	update_button_hints()
	button.text = button_text

func update_button_hints():
	clear_button_hints()
	var action_list = get_action_list()
	if action_list == null:
		return
	fill_button_hints_with_list(action_list)

func fill_button_hints_with_list(action_list):
	for action in action_list:
		var button_hint = create_button_hint_with_action(action)
		button_hints_container.add_child(button_hint)

func create_button_hint_with_action(action):
	var button_hint_text = action.as_text().to_lower()
	var button_hint_instance = button_hint.instance()
	var updated_button_hint_text = get_processed_button_hint_text(button_hint_text)
	button_hint_instance.set_text(updated_button_hint_text)
	return button_hint_instance

func get_processed_button_hint_text(button_hint_text):
	var result = button_hint_text
	result = result.split(" ")[0]
	return result

func get_action_list():
	var action_list = InputMap.get_action_list(key_action_title)
	if action_list and action_list.size() > 0:
		return action_list

func clear_button_hints():
	for child in button_hints_container.get_children():
		child.queue_free()
