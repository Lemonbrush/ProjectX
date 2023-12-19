extends Node

var fade_transition = preload("res://Project/UI/ScreenTransitionAnimations/FadeTransition/FadeLevelTransition.tscn")

func transition_to_level(scenePath):
	yield(get_tree().create_timer(.1),"timeout")
	var screenTransition = fade_transition.instance()
	add_child(screenTransition)
	yield(screenTransition, "screen_covered") 
	
	var packedScene = load(scenePath)
	if packedScene == null:
		print("Failed to transition. Scene value is null")
		return
	
	FileManager.save_game()
	
	var nextScene = packedScene.instance()
	print("Location ", nextScene.get_name(), " loaded")
	
	get_tree().paused = false
	
	if FileManager.save_file_resource.savedLevelScenes.has(nextScene.get_name()):
		# check if there is a save file for this scene
		var _scene = get_tree().change_scene_to(FileManager.save_file_resource.savedLevelScenes[nextScene.get_name()])
	else:
		var _scene = get_tree().change_scene_to(packedScene)

func transition_to_scene(scene):
	yield(get_tree().create_timer(.1),"timeout")
	var screenTransition = fade_transition.instance()
	add_child(screenTransition)
	yield(screenTransition, "screen_covered") 
	
	if scene == null:
		print("Failed to transition. Scene value is null")
		return
	
	print("Location ", scene.get_name(), " loaded")
	
	var _scene = get_tree().change_scene_to(scene)
