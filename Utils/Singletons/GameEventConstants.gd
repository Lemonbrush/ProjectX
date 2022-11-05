extends Node

var constants: Dictionary 

func set_default_constants():
	constants = {
		is_player_talked_to_shore_dweller = false,
		is_start_gate_open = false,
		is_lighthouse_key_available = false,
		is_banana_item_picked_up = false,
		is_red_band_dweller_get_banana = false,
		is_love_potion_last_ingredient_pickedup = false,
		is_love_potion_created = false,
		is_cauldron_dweller_spoken = false,
		is_wish_star_picked_up = false,
		is_mill_gear_clanged = true,
		is_mill_gear_activated = false,
		player_knows_about_kiss_nip = false,
		mill_ladder_placed = false,
		kissnip_picked_up = false,
		artist_created_artwork = false,
		artist_told_about_kitty = false,
		artist_told_about_artwork = false,
		artist_brush_given = false,
		is_artist_brush_picked_up = false,
		old_dweller_told_about_kittens = false,
		talked_to_eary_dweller = false,
		lovers_help_offered = false,
		lovers_she_has_been_asked_about_what_she_like = false,
		lovers_asking_what_she_like = false,
		lovers_she_has_been_told_about_him = false,
		lovers_asking_to_tell_about_him = false,
		lovers_she_has_been_told_a_story = false,
		lovers_asking_to_tell_a_story = false,
		lovers_girl_said_yes = false,
		lover_dweller_said_thank_you = false,
		left_water_tower_activated = false,
		right_water_tower_activated = false,
		grand_garden_water_level = 0.0,
		white_flower_quest_taken = false
	}
	EventBus.game_const_changed()

func set_constant(constant_name, value):
	if constants.has(constant_name):
		constants[constant_name] = value
		EventBus.game_const_changed()
		FileManager.save_game()
	else:
		print("Error setting game constant - ", constant_name, " with value ", value)

func get_constant(constant_name):
	if constants.has(constant_name):
		return constants[constant_name]
	else:
		print("Error getting game constant - ", constant_name)
		return

func is_cauldron_quest_completed():
	var is_wish_star_picked_up = GameEventConstants.constants.has("is_wish_star_picked_up") && GameEventConstants.constants["is_wish_star_picked_up"]
	var is_love_potion_created = GameEventConstants.constants.has("is_love_potion_created") && GameEventConstants.constants["is_love_potion_created"]
	return is_love_potion_created && is_wish_star_picked_up
