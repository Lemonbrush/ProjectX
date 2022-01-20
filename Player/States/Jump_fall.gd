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
	
	if player.glide:
		_state_machine.transition_to("Jump_glide")
	elif abs(y) < parent.jump_top_trashold:
		_state_machine.transition_to("Jump_top", {})
	elif y < parent.jump_top_trashold:
		_state_machine.transition_to("Jump", {})

func enter(_msg: Dictionary = {}):
	player.speed = player.max_run_speed
	animation.play("Jump_fall")
