extends Node2D

export(String) var dialog_id
export(NodePath) var interaction_controller_path
export(bool) var is_interaction_active = true

onready var dialogTextBox = $DialogTextBox

var dialogManager

func _ready():
	var interaction_controller = get_node(interaction_controller_path)
	if interaction_controller != null:
		interaction_controller.connect("on_leave", self, "on_leave")
		interaction_controller.connect("on_interact", self, "on_interact") 
	
	dialogTextBox.connect("pressed_button_number", self, "did_choose_option_number")
	
func did_choose_option_number(option_number):
	process_response_chosen_option(option_number)

func finish_dialog():
	Global.is_player_talking = false
	dialogTextBox.hide()
	dialogManager = null
	
func on_leave():
	finish_dialog()

func on_interact(_body = null):
	if dialog_id.empty() or !is_interaction_active:
		return
	
	var phrase
	if dialogManager == null:
		dialogManager = DialogManager.new(dialog_id)
		phrase = dialogManager.get_next_dialog("Initial")
	else:
		var next_phrase =  dialogManager.get_next_dialog()
		if next_phrase == null:
			finish_dialog()
			return
			
		phrase = next_phrase

	Global.is_player_talking = true
	process_gialog_interaction(phrase)

func process_gialog_interaction(phrase):
	if phrase == null:
		finish_dialog()
		return
	
	var phrase_type = phrase["type"]
	
	match phrase_type:
		"response":
			process_response(phrase)
			dialogTextBox.set_button_hint_visibility(false)
		"dialog":
			process_dialog(phrase)
			dialogTextBox.set_button_hint_visibility(true)
		_:
			finish_dialog()

func process_response(phrase):
	var responses = remove_unconditional_responses(phrase)
	dialogTextBox.show_text(phrase.text, responses)

func remove_unconditional_responses(phrase):
	var responses = []
	for response in phrase["responses"]:
		if response["conditions"] != null && dialogManager.is_conditions_satisfied(response["conditions"]) == false:
			continue
		responses.append(response)
	
	return responses

func process_dialog(phrase):
	dialogTextBox.show_text(phrase.text)

func process_response_chosen_option(chosen_option):
	if dialogManager != null:
		var phrase = dialogManager.get_next_dialog_by_option(chosen_option)
		process_gialog_interaction(phrase)
		
func set_dialog_id(new_dialog_id):
	dialog_id = new_dialog_id
	
func setup_interaction_mode(can_interact):
	is_interaction_active = can_interact
	if !can_interact:
		finish_dialog()