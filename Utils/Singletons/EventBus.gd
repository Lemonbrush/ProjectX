extends Node

signal cameraFocuseAnimation(zoom, time)
signal playerAnimationModeChange(isPlayerAnimating)
signal player_picked_up_item(item_name)
signal player_entered_door(nextScenePath)

signal start_shake_screen(duration, frequency, amplitude, infinity)
signal stop_shake_screen()

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
