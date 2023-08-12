extends Node2D

export(String) var dialog_id
export(NodePath) var interaction_controller_path
export(bool) var is_interaction_active = true
export (AudioStreamRandomPitch) var voice_sample

onready var dialogTextBox = $DialogTextBox
onready var voiceGenerator = $VoiceGeneratorAudioStreamPlayer

var dialogManager

# Lifecycle functions

func _ready():
	voiceGenerator.set_voice_sample(voice_sample)
	var interaction_controller = get_node(interaction_controller_path)
	if interaction_controller != null:
		interaction_controller.connect("on_leave", self, "on_leave")
		interaction_controller.connect("on_interact", self, "on_interact") 
	
	dialogTextBox.connect("pressed_button_number", self, "did_choose_option_number")

func on_leave():
	finish_dialog()

func on_interact(_body = null):
	if dialog_id.empty() or !is_interaction_active:
		return
	
	var phrase = extract_phrase_model()
	Global.is_player_talking = true
	process_dialog_interaction(phrase)

func did_choose_option_number(option_number):
	if dialogManager != null:
		var phrase = dialogManager.get_next_dialog_by_option(option_number)
		process_dialog_interaction(phrase)

# Functions

func set_voice_sample(stream):
	voiceGenerator.set_voice_sample(stream)

func extract_phrase_model():
	if dialogManager == null:
		dialogManager = DialogManager.new(dialog_id)
		return dialogManager.get_next_dialog("Initial")
	else:
		return dialogManager.get_next_dialog()

func set_dialog_id(new_dialog_id):
	dialog_id = new_dialog_id
	
func setup_interaction_mode(can_interact):
	is_interaction_active = can_interact
	if !can_interact:
		finish_dialog()

# Private functions

func process_dialog_interaction(phrase):
	if phrase == null:
		finish_dialog()
		return
	
	match phrase["type"]:
		"response":
			process_response_partition(phrase)
		"dialog":
			process_dialog_partition(phrase)
		_:
			finish_dialog()

func process_response_partition(phrase):
	var responses = get_valid_response_options(phrase)
	var text = phrase.text
	voiceGenerator.play(text)
	dialogTextBox.show_text(text, responses)
	dialogTextBox.set_button_hint_visibility(false)

func get_valid_response_options(phrase):
	var responses = []
	for response in phrase["responses"]:
		if response["conditions"] != null && dialogManager.is_conditions_satisfied(response["conditions"]) == false:
			continue
		responses.append(response)
	return responses

func process_dialog_partition(phrase):
	var text = phrase.text
	voiceGenerator.play(text)
	dialogTextBox.show_text(text)
	dialogTextBox.set_button_hint_visibility(true)

func finish_dialog():
	Global.is_player_talking = false
	dialogTextBox.hide()
	dialogManager = null
	voiceGenerator.stop()
