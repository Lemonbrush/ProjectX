extends PlayerState

var next_scene_path

func unhandled_input(event: InputEvent):
	player.unhandled_input(event)

func enter(msg: Dictionary = {}):
	if player.entering_scene_path:
		next_scene_path = msg["next_scene"]
	animation.play("Door_entering")
	
func on_animation_finished():
	LevelManager.transition_to_level(next_scene_path)
