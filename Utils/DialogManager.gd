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
	
	if phrase_id:
		return get_validated_phrase(current_dialog[phrase_id])
	else:
		var next_phrase_id = get_next_phrase_id()
		if next_phrase_id == null:
			return
			
		return get_validated_phrase(current_dialog[next_phrase_id])
	
func get_next_dialog_by_option(button_option):
	for response in current_dialog[current_phrase_id]["responses"]:
		if response["text"] == button_option:
			return get_next_dialog(response["next"])
	
##### Helper functions

func get_validated_phrase(next_phrase):
	if next_phrase["type"] == "condition":		
		if is_conditions_satisfied(next_phrase["conditions"]):
			return get_next_dialog(next_phrase["true"])
		else:
			return get_next_dialog(next_phrase["false"])
	else:
		return next_phrase

func is_conditions_satisfied(conditions):
	var condition_satisfied = true
	
	for condition in conditions:
		if !is_condition_satisfied(condition):
			condition_satisfied = false
	
	return condition_satisfied

func is_condition_satisfied(condition):
	var condition_name = condition["condition"]
	var condition_sign = condition["sign"]
	var condition_value = condition["value"]
	if GameEventConstants.constants.has(condition_name):
		var game_value = GameEventConstants.constants[condition_name]
		return calculate_result_by_condition_sign(condition_sign, game_value, condition_value)
	else:
		print("There is no such game constant as (", condition_name, ")")

func get_next_phrase_id():
	if current_phrase_id == null:
		return
	
	execute_commands_if_needed()
	
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
		print("Different condition value types: \n", "game value - ", typeof(value_1), "\ncondition value - ", typeof(value_2))
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
