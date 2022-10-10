extends Node

signal cameraFocuseAnimation(zoom, time)
signal playerAnimationModeChange(isPlayerAnimating)
signal player_picked_up_item(item_name)
signal player_entered_door(nextScenePath)

signal start_shake_screen(duration, frequency, amplitude, infinity)
signal stop_shake_screen()

signal debug_screen_visibility_updated()

signal game_const_changed()
signal show_lighthouse_key()

signal show_create_love_potion_cut_scene()

signal mill_gear_barrel_destructed()
signal show_mill_ladder_cut_scene()
signal show_cat_nip_creation_cut_scene()

func start_shake_screen(duration = 0.2, frequency = 16, amplitude = 2, infinity = true):
	emit_signal("start_shake_screen", duration, frequency, amplitude, infinity)

func stop_shake_screen():
	emit_signal("stop_shake_screen")

func camera_focuse_animation(zoom, time):
	emit_signal("cameraFocuseAnimation", zoom, time)

func player_animation_mode_change(isPlayerAnimating):
	emit_signal("playerAnimationModeChange", isPlayerAnimating)
	
func player_picked_up_item(item_name):
	emit_signal("player_picked_up_item", item_name)

func player_entered_door(nextScenePath):
	emit_signal("player_entered_door", nextScenePath)

func debug_screen_visibility_updated():
	emit_signal("debug_screen_visibility_updated")

func game_const_changed():
	emit_signal("game_const_changed")

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
