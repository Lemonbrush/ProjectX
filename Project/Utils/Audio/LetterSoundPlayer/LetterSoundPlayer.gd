extends Node2D
class_name ACVoiceBox

signal started_talking_phrase(phrase)
signal characters_sounded(characters)
signal finished_phrase()
signal skip_talking(full_text)

export (Resource) var letter_sounds_resource
export (float) var PITCH_MULTIPLIER_RANGE := 0.3
export (float) var INFLECTION_SHIFT := 0.4
export (float, 2.5, 4.5) var base_pitch := 3.5

onready var audioPlayer = $AudioStreamPlayer

var remaining_sounds := []

# Lifecycle functions

func _ready():
	var _finished_connection = audioPlayer.connect("finished", self, "play_next_sound")
	
# Functions

func play(text: String):
	reset()
	if letter_sounds_resource == null:
		emit_signal("skip_talking", text)
		return
	parse_input_string(text)
	emit_signal("started_talking_phrase", text)
	play_next_sound()

func set_letter_sounds_resource(resource):
	letter_sounds_resource = resource
	if letter_sounds_resource:
		letter_sounds_resource.load_sounds_dictionary()

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
	# Skip to next sound if no sound exists for text
	if next_symbol.sound == '':
		play_next_sound()
		return
	var sound: AudioStreamSample = letter_sounds_resource.get_sound_for_letter(next_symbol.sound)
	# Add some randomness to pitch plus optional inflection for end word in questions
	audioPlayer.pitch_scale = base_pitch + (PITCH_MULTIPLIER_RANGE * randf()) + (INFLECTION_SHIFT if next_symbol.inflective else 0.0)
	audioPlayer.stream = sound
	audioPlayer.play()

func parse_input_string(in_string: String):
	for word in in_string.split(' '):
		parse_word(word)
		add_symbol(' ', ' ', false)
	
func parse_word(word: String):
	var skip_char := false
	var is_inflective := word.length() > 0 and word[word.length() - 1] == '?'
	for i in range(len(word)):
		if skip_char:
			skip_char = false
			continue
		# If not the last letter, check if next letter makes a two letter substring, e.g. 'th'
		if i < len(word) - 1:
			var two_character_substring = word.substr(i, i+2)
			if two_character_substring.to_lower() in letter_sounds_resource.sounds.keys():
				add_symbol(two_character_substring.to_lower(), two_character_substring, is_inflective)
				skip_char = true
				continue
		# Otherwise check if single character has matching sound, otherwise add a blank character
		if word[i].to_lower() in letter_sounds_resource.sounds.keys():
			add_symbol(word[i].to_lower(), word[i], is_inflective)
		else:
			add_symbol('', word[i], false)

func add_symbol(sound: String, characters: String, inflective: bool):
	remaining_sounds.append({
		'sound': sound,
		'characters': characters,
		'inflective': inflective
	})
