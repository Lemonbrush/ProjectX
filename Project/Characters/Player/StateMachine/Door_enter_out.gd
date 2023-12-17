extends PlayerState

func unhandled_input(event: InputEvent):
	player.unhandled_input(event)

func enter(_msg: Dictionary = {}):
	animation.play("Door_entering_out")
	
func on_animation_finished():
	player.is_entering_out = false
	_state_machine.transition_to("Idle", {})
