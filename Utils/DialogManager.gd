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
	current_phrase_id = phrase_id
	
	if phrase_id:
		print(current_dialog[phrase_id])
		return current_dialog[phrase_id]
	else:
		print(current_dialog[get_next_phrase_id()])
		return current_dialog[get_next_phrase_id()]

##### Helper functions

func get_next_phrase_id():
	return current_dialog[current_phrase_id]["next"]
