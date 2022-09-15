extends Node

var constants: Dictionary 

func set_default_constants():
	constants = {
		is_player_talked_to_shore_dweller = false,
		is_start_gate_open = false,
		is_lighthouse_key_available = false,
		is_banana_item_picked_up = false
	}
	EventBus.game_const_changed()

func set_constant(constant_name, value):
	if constants.has(constant_name):
		constants[constant_name] = value
		EventBus.game_const_changed()
		FileManager.save_game()
	else:
		print("Error setting game constant")
