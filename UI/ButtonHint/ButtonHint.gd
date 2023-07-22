extends Control

export (String) var button_action = ""

onready var label = $PanelContainer/MarginContainer/Label

func _ready():
	setup_hint()

func set_hint_action(button_action):
	self.button_action = button_action
	setup_hint()

func setup_hint():
	var action_list = InputMap.get_action_list(button_action)
	if action_list and action_list.size() > 0:
		label.text = action_list[0].as_text().to_lower()
		return
	label.text = "?"
