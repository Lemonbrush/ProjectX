extends Node2D

signal did_receive_text_dialog(text)
signal did_receive_response_dialog(text, responses)
signal did_receive_error(text)

export(String) var dialog_id

var dialogManager

# Functions

func request_dialog():
	var dialog_model = get_next_dialog_model()
	process_dialog_model(dialog_model)

func did_choose_dialog_option(option_text):
	if dialogManager == null:
		return
	var phrase = dialogManager.get_next_dialog_by_option(option_text)
	process_dialog_model(phrase)

func reset():
	dialogManager = null

func set_dialog_id(new_dialog_id):
	dialog_id = new_dialog_id

# Private functions

func process_dialog_model(phrase):
	if phrase == null:
		throw_error("Failed to process dialog model")
		return
	
	match phrase["type"]:
		"response":
			process_response_partition(phrase)
		"dialog":
			process_dialog_partition(phrase)
		_:
			throw_error("Failed to detect phrase type")

func process_response_partition(phrase):
	var responses = get_valid_response_options(phrase)
	var text = phrase.text
	emit_signal("did_receive_response_dialog", text, responses)

func get_valid_response_options(phrase):
	var responses = []
	for response in phrase["responses"]:
		if response["conditions"] != null && dialogManager.is_conditions_satisfied(response["conditions"]) == false:
			continue
		responses.append(response)
	return responses

func process_dialog_partition(phrase):
	var text = phrase.text
	emit_signal("did_receive_text_dialog", text)

func throw_error(text):
	emit_signal("did_receive_error", text)

func get_next_dialog_model():
	if dialogManager == null:
		dialogManager = DialogService.new(dialog_id)
		return dialogManager.get_next_dialog("Initial")
	else:
		return dialogManager.get_next_dialog()
