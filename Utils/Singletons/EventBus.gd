extends Node

signal cameraFocuseAnimation(zoom, time)

signal playerAnimationModeChange(isPlayerAnimating)

func camera_focuse_animation(zoom, time):
	emit_signal("cameraFocuseAnimation", zoom, time)

func player_animation_mode_change(isPlayerAnimating):
	emit_signal("playerAnimationModeChange", isPlayerAnimating)
