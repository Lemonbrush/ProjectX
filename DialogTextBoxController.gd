extends Node2D

export(String) var dialog_id
export(NodePath) var interaction_controller_path

onready var dialogTextBox = $DialogTextBox

var dialogManager

func _ready():
	var interaction_controller = get_node(interaction_controller_path) 
	interaction_controller.connect("on_leave", self, "on_leave")
	interaction_controller.connect("on_interact", self, "on_interact") 
	
	dialogTextBox.connect("pressed_button_number", self, "did_choose_option_number")
	
func did_choose_option_number(option_number):
	pass

func on_leave():
	dialogTextBox.hide()
	dialogManager = null

func on_interact(_body):
	if dialog_id == null:
		return
	
	var phrase
	if dialogManager == null:
		dialogManager = DialogManager.new(dialog_id)
		phrase = dialogManager.get_next_dialog("intro")
	else:
		phrase = dialogManager.get_next_dialog()
		
	var phrase_type = phrase["type"]
	
	match phrase_type:
		"response":
			process_response(phrase)
		"dialog":
			process_dialog(phrase)
		_:
			return

func process_response(phrase):
	dialogTextBox.show_text(phrase.text, phrase["responses"])

func process_dialog(phrase):
	pass
		
func set_dialog_id(dialog_id):
	self.dialog_id = dialog_id
