extends Resource
class_name VoiceGeneratorConfigurationModel

enum VoiceMode { 
	SUPER_SLOW, 
	SLOW, 
	WITHOUT_EFFECTS, 
	NORMAL, 
	FAST, 
	SUPER_FAST 
	}

export (Resource) var letter_sounds_resource
export (VoiceMode) var voice_mode = VoiceMode.NORMAL
export (float) var volumeDB = 0

var PITCH_MULTIPLIER_RANGE := 0.5
var base_pitch := 1.5

func get_letter_sounds_resource():
	return letter_sounds_resource

func get_pitch_multiplier():
	update_values()
	return PITCH_MULTIPLIER_RANGE

func get_base_pitch():
	update_values()
	return base_pitch

func get_volume_DB():
	return volumeDB

func update_values():
	match voice_mode:
		VoiceMode.SUPER_SLOW:
			base_pitch = 0.5
		VoiceMode.SLOW:
			base_pitch = 0.8
		VoiceMode.WITHOUT_EFFECTS:
			base_pitch = 1
		VoiceMode.NORMAL:
			base_pitch = 1.5
		VoiceMode.FAST:
			base_pitch = 2
		VoiceMode.SUPER_FAST:
			base_pitch = 2.5
