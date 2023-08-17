extends LetterSoundsModel

export (Array, AudioStreamSample) var letter_audio_sample

func load_sounds_dictionary():
	pass

func get_available_letters_array():
	return []

func get_sound_for_letter(_letter):
	var size = letter_audio_sample.size()
	return letter_audio_sample[randi() % size]
