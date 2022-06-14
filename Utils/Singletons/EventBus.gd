extends Node

signal cameraFocuseAnimation(zoom, time)

signal playerAnimationModeChange(isPlayerAnimating)

signal player_picked_up_item(item_name)

signal player_entered_door(nextScenePath)

func camera_focuse_animation(zoom, time):
	emit_signal("cameraFocuseAnimation", zoom, time)

func player_animation_mode_change(isPlayerAnimating):
	emit_signal("playerAnimationModeChange", isPlayerAnimating)
	
func player_picked_up_item(item_name):
	emit_signal("player_picked_up_item", item_name)

func player_entered_door(nextScenePath):
	emit_signal("player_entered_door", nextScenePath)
