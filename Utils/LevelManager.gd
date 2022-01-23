extends Node

var fade_transition = preload("res://UI/ScreenTransitionAnimations/FadeTransition/FadeLevelTransition.tscn")

func transition_to_level(levelPath):
	yield(get_tree().create_timer(.1),"timeout")
	var screenTransition = fade_transition.instance()
	add_child(screenTransition)
	
	yield(screenTransition, "screen_covered") 
	var _scene = get_tree().change_scene(levelPath)
