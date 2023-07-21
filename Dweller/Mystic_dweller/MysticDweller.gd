extends AbstractDweller

var mysticDwellerHideAnimation = preload("res://Dweller/Mystic_dweller/Animations/MysticDwellerHidingAnimation.tscn")

func show_hide_animation():
	animationPlayer.play("Hiding")

func place_hide_animation_scene():
	var mysticDwellerHideAnimationInstance = mysticDwellerHideAnimation.instance()
	get_parent().add_child(mysticDwellerHideAnimationInstance)
	mysticDwellerHideAnimationInstance.scale = Vector2.ONE * body.scale
	mysticDwellerHideAnimationInstance.global_position = global_position
