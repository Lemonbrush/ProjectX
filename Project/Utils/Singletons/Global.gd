extends Node

var door_name = null
var is_game_loaded = false
var is_player_talking = false
var active_interaction_controller

func reset_state():
	door_name = null
	is_game_loaded = false
	is_player_talking = false
	active_interaction_controller = null
