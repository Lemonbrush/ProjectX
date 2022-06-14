extends PlayerState

func unhandled_input(event: InputEvent):
	player.unhandled_input(event)

func enter(_msg: Dictionary = {}):
	animation.play("Door_entering_out")
	var _connection = animation.connect("animation_finished", self, "on_animation_finished")
	
func exit():
	animation.disconnect("animation_finished", self, "on_animation_finished")
	
func on_animation_finished(_finished):
	player.is_entering_out = false
	_state_machine.transition_to("Idle", {})
