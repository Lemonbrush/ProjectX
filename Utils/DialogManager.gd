extends Node
class_name DialogManager

var current_dialog
var current_phrase_id

func _init(dialog_id: String):
	var file = File.new()
	var error = file.open("res://ProjectResources/Dialogs/%s.json" % dialog_id, File.READ)
	if error == OK:
		current_dialog = parse_json(file.get_as_text())
	else:
		print("Error - %s" % error)

func get_next_dialog(phrase_id = null):
	if phrase_id != null:
		current_phrase_id = phrase_id
	
	execute_commands_if_needed()
	
	if phrase_id:
		return get_validated_phrase(current_dialog[phrase_id])
	else:
		var next_phrase_id = get_next_phrase_id()
		if next_phrase_id == null:
			return
			
		return get_validated_phrase(current_dialog[next_phrase_id])
	
func get_next_dialog_by_option(button_option):
	var next_dialog_id = current_dialog[current_phrase_id]["responses"][button_option]["next"]
	return get_next_dialog(next_dialog_id)
	
##### Helper functions

func get_validated_phrase(next_phrase):
	if next_phrase["type"] == "condition":
		return process_condition(next_phrase)
	else:
		return next_phrase

func process_condition(condition_node):
	var condition_name = condition_node["condition_name"]
	var condition_value = condition_node["condition_value"]
	if GameEventConstants.constants.has(condition_name):
		var game_value = GameEventConstants.constants[condition_name]
		var condition_sign = condition_node["condition_sign"]
		if calculate_result_by_condition_sign(condition_sign, game_value, condition_value):
			return get_next_dialog(condition_node["condition_satisfied"])
		else:
			return get_next_dialog(condition_node["default"])

func get_next_phrase_id():
	if current_phrase_id == null:
		return
		
	if current_dialog[current_phrase_id].has("next"):
		current_phrase_id = current_dialog[current_phrase_id]["next"]
	
	return current_phrase_id

func execute_commands_if_needed():
	var current_phrase = current_dialog[current_phrase_id]
	if current_phrase.has("commands"):
		var commands = current_phrase["commands"]
		CommandHandler.executeCommands(commands)

func calculate_result_by_condition_sign(condition_sign, value_1, value_2):
	if typeof(value_1) != typeof(value_2):
		return false
	
	match condition_sign:
		"=":
			return value_1 == value_2
		">":
			return value_1 > value_2
		"<":
			return value_1 < value_2
		_:
			return false
