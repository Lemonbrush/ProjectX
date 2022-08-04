extends Node

var constants: Dictionary = {
	is_player_talked_to_shore_dweller = false
}

func set_constant(constant_name, value):
	if constants.has(constant_name):
		constants[constant_name] = value
		EventBus.game_const_changed()
	else:
		print("Error setting game constant")
