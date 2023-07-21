extends Node

signal did_reset_game_constants()
signal did_update_cursor_setting()
signal camera_focus_animation(zoomValue, time)
signal camera_focus_default_zoom(time)
signal playerAnimationModeChange(isPlayerAnimating)
signal player_picked_up_item(item_name)
signal player_entered_door(nextScenePath)

signal start_shake_screen(duration, frequency, amplitude, infinity)
signal stop_shake_screen()

signal debug_screen_visibility_updated()

signal game_const_changed(constant_name, value)
signal show_lighthouse_key()

signal show_create_love_potion_cut_scene()

signal mill_gear_barrel_destructed()
signal show_mill_ladder_cut_scene()
signal show_cat_nip_creation_cut_scene()

signal show_art_creation_cut_scene()
signal show_artist_brush_gift_scene()

signal show_lovers_cut_scene()

signal show_white_flower_grow_cut_scene()
signal show_cuctus_love_particles()

signal guardian_statue_lift_up()
signal guardian_statue_lift_down()
signal show_creator_house_desk_scene()

signal show_heart_assembling_cutscene()
signal show_mystic_dweller_heart_assembler_disappear_cutscene()

signal show_activate_pillars_cutscene()
signal did_place_item_at_pedestal(item_name)
signal show_final_level_door_opening_cutscene()

signal show_red_thred_cutscene()

signal start_proposal_stage()
signal did_finish_the_first_mystic_dweller_dialog()
signal personal_garden_mystic_dweller_hide()

func start_shake_screen(duration = 0.2, frequency = 16, amplitude = 2, infinity = true):
	emit_signal("start_shake_screen", duration, frequency, amplitude, infinity)

func stop_shake_screen():
	emit_signal("stop_shake_screen")

func camera_focus_animation(zoomValue, time):
	emit_signal("camera_focus_animation", zoomValue, time)

func camera_focus_default_zoom(time):
	emit_signal("camera_focus_default_zoom", time)

func player_animation_mode_change(isPlayerAnimating):
	emit_signal("playerAnimationModeChange", isPlayerAnimating)
	
func player_picked_up_item(item_name):
	emit_signal("player_picked_up_item", item_name)

func player_entered_door(nextScenePath):
	FileManager.save_game()
	emit_signal("player_entered_door", nextScenePath)

func debug_screen_visibility_updated():
	emit_signal("debug_screen_visibility_updated")

func game_const_changed(constant_name, value):
	emit_signal("game_const_changed", constant_name, value)

func show_lighthouse_key():
	emit_signal("show_lighthouse_key")

func show_create_love_potion_cut_scene():
	emit_signal("show_create_love_potion_cut_scene")
	
func mill_gear_barrel_destructed():
	emit_signal("mill_gear_barrel_destructed")

func show_mill_ladder_cut_scene():
	emit_signal("show_mill_ladder_cut_scene")

func show_cat_nip_creation_cut_scene():
	emit_signal("show_cat_nip_creation_cut_scene")

func show_art_creation_cut_scene():
	emit_signal("show_art_creation_cut_scene")

func show_artist_brush_gift_scene():
	emit_signal("show_artist_brush_gift_scene")

func show_lovers_cut_scene():
	emit_signal("show_lovers_cut_scene")
	
func show_white_flower_grow_cut_scene():
	emit_signal("show_white_flower_grow_cut_scene")

func show_cuctus_love_particles():
	emit_signal("show_cuctus_love_particles")

func guardian_statue_lift_up():
	emit_signal("guardian_statue_lift_up")
	
func guardian_statue_lift_down():
	emit_signal("guardian_statue_lift_down")

func show_creator_house_desk_scene():
	emit_signal("show_creator_house_desk_scene")

func show_heart_assembling_cutscene():
	emit_signal("show_heart_assembling_cutscene")

func show_mystic_dweller_heart_assembler_disappear_cutscene():
	emit_signal("show_mystic_dweller_heart_assembler_disappear_cutscene")

func did_update_cursor_setting():
	emit_signal("did_update_cursor_setting")

func show_activate_pillars_cutscene():
	emit_signal("show_activate_pillars_cutscene")

func did_place_item_at_pedestal(item_name):
	emit_signal("did_place_item_at_pedestal", item_name)

func show_final_level_door_opening_cutscene():
	emit_signal("show_final_level_door_opening_cutscene")

func did_reset_game_constants():
	emit_signal("did_reset_game_constants")

func start_proposal_stage():
	emit_signal("start_proposal_stage")

func show_red_thred_cutscene():
	emit_signal("show_red_thred_cutscene")

func did_finish_the_first_mystic_dweller_dialog():
	emit_signal("did_finish_the_first_mystic_dweller_dialog")

func personal_garden_mystic_dweller_hide():
	emit_signal("personal_garden_mystic_dweller_hide")
