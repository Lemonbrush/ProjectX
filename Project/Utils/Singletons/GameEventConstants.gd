extends Node

var constants: Dictionary 

func set_default_constants():
	constants = {
		default_camera_zoom = 0.7,
		kissnip_picked_up = false,
		heart_key_picked_up = false,
		sketch_picked_up = false,
		is_artist_brush_picked_up = false,
		redThredItem_picked_up = false,
		assembled_heart_picked_uo = false,
		blue_butterfly_pickedup = false,
		special_flower_picked_up = false,
		did_encounter_mystic_dweller_the_first_time = false,
		is_start_gate_first_entrance = true,
		is_player_talked_to_shore_dweller = false,
		is_start_gate_open = false,
		is_lighthouse_key_available = false,
		is_banana_item_picked_up = false,
		is_red_band_dweller_get_banana = false,
		banana_quest_taken = false,
		is_love_potion_last_ingredient_pickedup = false,
		is_love_potion_created = false,
		is_cauldron_dweller_spoken = false,
		is_wish_star_picked_up = false,
		is_mill_gear_clanged = true,
		is_mill_gear_activated = false,
		player_knows_about_kiss_nip = false,
		mill_ladder_placed = false,
		artist_created_artwork = false,
		artist_told_about_kitty = false,
		artist_told_about_artwork = false,
		artist_brush_given = false,
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
		white_flower_quest_taken = false,
		is_cactus_hugged = false,
		grand_flower_did_grow = false,
		guardian_statue_satisfied = false,
		is_creator_house_desk_inspected = false,
		artist_gifted_the_thread = false,
		did_speak_to_creator_house_welcomer = false,
		left_side_heart_picked_up = false,
		right_side_heart_picked_up = false,
		did_trigger_heart_assembling_cutscene = false,
		did_mystic_dweller_activate_pillars = false,
		did_put_all_all_items_on_pedestals = false,
		did_say_where_special_flower_is = false,
		special_flower_mentioned = false,
		red_thred_quest_finished = false,
		the_flower_mentioned = false,
		last_ingredient_mentioned = false,
		lighthouse_lamp_ladder_placed = false,
		player_ignited_lighthouse_lamp = false,
		did_finish_lighthouse_quest = false,
		old_lower_said_hello = false,
		player_knows_about_the_first_kiss_ghost = false,
		picked_up_empty_jur = false,
		did_show_empty_jur = false
	}

func set_constant(constant_name, value):
	if constants.has(constant_name):
		constants[constant_name] = value
		EventBus.game_const_changed(constant_name, value)
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