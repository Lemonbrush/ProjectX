extends Node2D

enum DIALOG_TYPE {
	DIALOG,
	CHOICE
}

export(String) var dialog_id
export(NodePath) var interaction_controller_path
export (Resource) var voice_generator_configuration_file
export(bool) var is_interaction_active = true

onready var dialogTextBox = $DialogTextBox
onready var voiceGenerator = $LetterSoundPlayer
onready var dialogManager = $DialogManager

var current_text = ""
var target_text = ""
var current_dialog_type = DIALOG_TYPE.DIALOG

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
	
	if current_text != target_text:
		skip_dialog_animation(target_text)
		return
	
	current_text = ""
	target_text = ""
	show_dialog_text_box()
	dialogManager.request_dialog()

func did_choose_dialog_option(option_number):
	dialogManager.did_choose_dialog_option(option_number)

func voice_generator_did_pronounced_text(pronounced_text):
	current_text += pronounced_text
	var current_text_length = float(current_text.length())
	var target_text_length = float(target_text.length())
	
	if target_text_length == 0:
		target_text_length = 1
	
	var one_percent = 1.0/target_text_length
	var pronaunced_percents = one_percent * current_text_length
	var new_percent = 1.0 - (1.0 - pronaunced_percents)
	dialogTextBox.set_label_text_percent_visible(new_percent)

func voice_generator_did_start_talking(_phrase_text):
	reset_dialogTextBox()

func voice_generator_did_fibish_talking():
	current_text = target_text
	show_button_hint_if_needed()

func voice_generator_skipped_talking(full_text):
	skip_dialog_animation(full_text)

func did_receive_text_dialog(text):
	if text == null:
		finish_dialog()
		return
	current_dialog_type = DIALOG_TYPE.DIALOG
	reset_dialogTextBox()
	target_text = text
	voiceGenerator.play(text)
	dialogTextBox.set_label_text(text)

func did_receive_response_dialog(text, responses):
	if responses == null:
		finish_dialog()
		return
	current_dialog_type = DIALOG_TYPE.CHOICE
	reset_dialogTextBox()
	voiceGenerator.reset()
	if text:
		voiceGenerator.play(text)
		dialogTextBox.set_label_text(text)
	dialogTextBox.show_button_options(responses)

func did_receive_error(text):
	print(text)
	finish_dialog()

# Functions

func show_button_hint_if_needed():
	if current_dialog_type != DIALOG_TYPE.CHOICE:
		dialogTextBox.show_button_hint()

func skip_dialog_animation(full_text):
	voiceGenerator.reset()
	current_text = full_text
	dialogTextBox.set_label_text_percent_visible(1)
	show_button_hint_if_needed()

func reset_dialogTextBox():
	dialogTextBox.reset_textBox()

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

func show_dialog_text_box():
	dialogTextBox.show()

func finish_dialog():
	Global.is_player_talking = false
	dialogTextBox.hide()
	dialogManager.reset()
	voiceGenerator.reset()

func configure_interaction_controller():
	var interaction_controller = get_node(interaction_controller_path)
	if interaction_controller == null:
		return	
	interaction_controller.connect("on_leave", self, "on_leave")
	interaction_controller.connect("on_interact", self, "on_interact")

func configure_voice_generator():
	voiceGenerator.set_letter_sounds_resource(voice_generator_configuration_file)
	voiceGenerator.connect("characters_sounded", self, "voice_generator_did_pronounced_text")
	voiceGenerator.connect("finished_phrase", self, "voice_generator_did_fibish_talking")
	voiceGenerator.connect("started_talking_phrase", self, "voice_generator_did_start_talking")
	voiceGenerator.connect("skip_talking", self, "voice_generator_skipped_talking")

func configure_dialogTextBox():
	dialogTextBox.instant_hide()
	dialogTextBox.connect("did_press_button_with_text", self, "did_choose_dialog_option")

func configure_dialog_manager():
	dialogManager.set_dialog_id(dialog_id)
	dialogManager.connect("did_receive_text_dialog", self, "did_receive_text_dialog")
	dialogManager.connect("did_receive_response_dialog", self, "did_receive_response_dialog")
	dialogManager.connect("did_receive_error", self, "did_receive_error")
