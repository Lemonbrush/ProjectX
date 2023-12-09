extends Node2D

onready var animationPlayer = $AnimationPlayer
onready var working_gears_audio_player = $Audio/WorkingGearAudioStreamPlayer
onready var success_audio_player = $Audio/SuccessAudioStreamPlayer

func _ready():
	if GameEventConstants.constants.has("is_mill_gear_clanged") &&  GameEventConstants.constants["is_mill_gear_clanged"]:
		animationPlayer.play("Locked")
	else:
		mill_gear_cleared()
		
	var _connection = EventBus.connect("mill_gear_barrel_destructed", self, "did_hit_barrel")

func mill_gear_cleared():
	working_gears_audio_player.play()
	animationPlayer.play("Run")

func did_hit_barrel():
	success_audio_player.play()
	mill_gear_cleared()
