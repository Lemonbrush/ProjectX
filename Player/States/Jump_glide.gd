extends PlayerState

func unhandled_input(event: InputEvent):
	parent.unhandled_input(event)

func physics_process(delta: float):
	parent.physics_process(delta)

func process(delta):
	parent.process(delta)
	state_check()

func state_check():
	if !parent.state_check():
		return
		
	var y = player.velocity.y

	if !player.glide:
		if abs(y) < parent.jump_top_trashold:
			_state_machine.transition_to("Jump_top", {})
		elif y > 0.0:
			_state_machine.transition_to("Jump_fall", {})
		else:
			_state_machine.transition_to("Jump", {})

func enter(_msg: Dictionary = {}):
	player.speed = player.max_run_speed
	
	animation.play("Glide_start") 
	animation.queue("Jump_glide")
