extends Node2D
class_name ACVoiceBox

signal started_talking_phrase(phrase)
signal characters_sounded(characters)
signal finished_phrase()
signal skip_talking(full_text)

export (Resource) var letter_sounds_resource
export (Resource) var default_letter_sounds_resource
export (float) var PITCH_MULTIPLIER_RANGE := 0.2
export (float) var base_pitch := 1.5

onready var audioPlayer = $AudioStreamPlayer

var active_sound_resource
var remaining_sounds := []

# Lifecycle functions

func _ready():
	var _finished_connection = audioPlayer.connect("finished", self, "play_next_sound")
	
# Functions

func configure_sound_resource_file(text):
	if letter_sounds_resource != null:
		active_sound_resource = letter_sounds_resource
		return
	
	if default_letter_sounds_resource != null:
		active_sound_resource = default_letter_sounds_resource
		active_sound_resource.load_sounds_dictionary()
		return
	
	emit_signal("skip_talking", text)
	
func play(text: String):
	reset()
	configure_sound_resource_file(text)
	parse_input_string(text)
	emit_signal("started_talking_phrase", text)
	play_next_sound()

func set_letter_sounds_resource(configurationModel: VoiceGeneratorConfigurationModel):
	if configurationModel == null:
		return
	
	letter_sounds_resource = configurationModel.get_letter_sounds_resource()
	if letter_sounds_resource:
		letter_sounds_resource.load_sounds_dictionary()
	
	PITCH_MULTIPLIER_RANGE = configurationModel.get_pitch_multiplier()
	base_pitch = configurationModel.get_base_pitch()

func reset():
	audioPlayer.stop()
	remaining_sounds = []

# Private functions

func play_next_sound():
	if len(remaining_sounds) == 0:
		emit_signal("finished_phrase")
		return
	
	var next_symbol = remaining_sounds.pop_front()
	emit_signal("characters_sounded", next_symbol.characters)
	
	if next_symbol.sound == '':
		play_next_sound()
		return
	
	var sound: AudioStreamSample = active_sound_resource.get_sound_for_letter(next_symbol.sound)
	audioPlayer.pitch_scale = base_pitch + (PITCH_MULTIPLIER_RANGE * randf())
	audioPlayer.stream = sound
	audioPlayer.play()

func parse_input_string(in_string: String):
	for word in in_string.split(' '):
		parse_word(word)
		add_symbol('', ' ')
	
func parse_word(word: String):
	for i in range(len(word)):
		if word[i].to_lower() in active_sound_resource.sounds.keys():
			add_symbol(word[i].to_lower(), word[i])
		else:
			add_symbol('', word[i])

func add_symbol(sound: String, characters: String):
	remaining_sounds.append({
		'sound': sound,
		'characters': characters
	})
