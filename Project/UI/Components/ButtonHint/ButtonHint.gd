extends MarginContainer

export (String) var button_action = ""
export (String) var text = ""

onready var label = $PanelContainer/MarginContainer/Label
onready var appear_animator = $ButtonHintAppearAnimator

func _ready():
	setup_ui()
	#setup_hint()

func show():
	appear_animator.show()

func hide():
	appear_animator.hide()

func instant_show():
	appear_animator.instant_show()

func instant_hide():
	appear_animator.instant_hide()

func set_text(text):
	if text:
		self.text = text
		return
	self.text = "?"

func setup_ui():
	label.text = text

func set_hint_action(new_button_action):
	button_action = new_button_action
	setup_hint()

func setup_hint():
	var action_list = InputMap.get_action_list(button_action)
	if action_list and action_list.size() > 0:
		label.text = action_list[0].as_text().to_lower()
		return
	label.text = "?"
