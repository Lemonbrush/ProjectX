extends Node

export(int) var numberToPlay = 2
export(bool) var enablePitchRandomization = true
export(float) var minPitchScale = 0.9
export(float) var maxPitchScale = 1.1

var rngNumber = RandomNumberGenerator.new()

func _ready():
	rngNumber.randomize()

func play():
	var playerNodes = get_idle_stream_players()
	
	for i in numberToPlay:
		if playerNodes.size() == 0:
			break
		var idx = rngNumber.randi_range(0, playerNodes.size() - 1)
		
		if enablePitchRandomization:
			playerNodes[idx].pitch_scale = rngNumber.randf_range(minPitchScale, maxPitchScale)
		
		playerNodes[idx].play()
		playerNodes.remove(idx)


func get_idle_stream_players():
	var validNodes = []
	for streamPlayer in get_children():
		if !streamPlayer.playing && streamPlayer is AudioStreamPlayer:
			validNodes.append(streamPlayer)
	return validNodes
