extends Node2D

export(String) var dialog_id
export(NodePath) var interaction_controller_path
export (Resource) var voice_sample
export(bool) var is_interaction_active = true

onready var dialogTextBox = $DialogTextBox
onready var voiceGenerator = $LetterSoundPlayer
onready var dialogManager = $DialogManager

var current_text = ""

# Lifecycle

func _ready():
	configure_voice_generator()
	configure_interaction_controller()
	configure_dialogTextBox()
	configure_dialog_manager()

func on_leave():
	finish_dialog()

func on_interact(_body = null):
	if dialog_id.empty() or !is_interaction_active:
		return
	Global.is_player_talking = true
	dialogManager.request_dialog()

func did_choose_dialog_option(option_number):
	dialogManager.did_choose_dialog_option(option_number)

func voice_generator_did_pronounced_text(pronounced_text):
	current_text += pronounced_text
	dialogTextBox.set_label_text(current_text)

func voice_generator_did_start_talking(_phrase_text):
	reset_dialogTextBox()

func voice_generator_did_fibish_talking():
	dialogTextBox.show_button_hint()

func did_receive_text_dialog(text):
	if text == null:
		finish_dialog()
		return
	reset_dialogTextBox()
	voiceGenerator.play(text)
	dialogTextBox.show()
	dialogTextBox.hide_buttons()

func did_receive_response_dialog(text, responses):
	if responses == null:
		finish_dialog()
		return
	reset_dialogTextBox()
	if text:
		voiceGenerator.play(text)
	
	dialogTextBox.show_button_options(responses)

func did_receive_error(text):
	print(text)
	finish_dialog()

# Functions

func reset_dialogTextBox():
	current_text = ""
	dialogTextBox.set_label_text("")
	dialogTextBox.hide_button_hint()

func set_letter_sounds_resource(stream):
	voiceGenerator.set_letter_sounds_resource(stream)

func set_dialog_id(new_dialog_id):
	dialog_id = new_dialog_id
	dialogManager.set_dialog_id(new_dialog_id)
	
func setup_interaction_mode(can_interact):
	is_interaction_active = can_interact
	if !can_interact:
		finish_dialog()

# Private functions

func finish_dialog():
	Global.is_player_talking = false
	dialogTextBox.hide()
	dialogManager.reset()
	voiceGenerator.stop()

func configure_interaction_controller():
	var interaction_controller = get_node(interaction_controller_path)
	if interaction_controller == null:
		return	
	interaction_controller.connect("on_leave", self, "on_leave")
	interaction_controller.connect("on_interact", self, "on_interact")

func configure_voice_generator():
	voiceGenerator.set_letter_sounds_resource(voice_sample)
	voiceGenerator.connect("characters_sounded", self, "voice_generator_did_pronounced_text")
	voiceGenerator.connect("finished_phrase", self, "voice_generator_did_fibish_talking")
	voiceGenerator.connect("started_talking_phrase", self, "voice_generator_did_start_talking")

func configure_dialogTextBox():
	dialogTextBox.connect("did_press_button_with_text", self, "did_choose_dialog_option")

func configure_dialog_manager():
	dialogManager.set_dialog_id(dialog_id)
	dialogManager.connect("did_receive_text_dialog", self, "did_receive_text_dialog")
	dialogManager.connect("did_receive_response_dialog", self, "did_receive_response_dialog")
	dialogManager.connect("did_receive_error", self, "did_receive_error")
