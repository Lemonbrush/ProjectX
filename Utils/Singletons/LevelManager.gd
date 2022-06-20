extends Node

var fade_transition = preload("res://UI/ScreenTransitionAnimations/FadeTransition/FadeLevelTransition.tscn")

func transition_to_level(scenePath):
	FileManager.save_game()
	
	var packedScene = load(scenePath)
	var nextScene = packedScene.instance()
	
	yield(get_tree().create_timer(.1),"timeout")
	var screenTransition = fade_transition.instance()
	add_child(screenTransition)
	
	yield(screenTransition, "screen_covered") 
	
	print("Location ", nextScene.get_name(), " loaded")
	
	if FileManager.save_file_resource.savedLevelScenes.has(nextScene.get_name()):
		var _scene = get_tree().change_scene_to(FileManager.save_file_resource.savedLevelScenes[nextScene.get_name()])
	else:
		var _scene = get_tree().change_scene_to(packedScene)
		
	FileManager.save_game()
