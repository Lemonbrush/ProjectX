extends PlayerState

func unhandled_input(event: InputEvent):
	if event.is_action_pressed("Attack"):
		_state_machine.transition_to("Attack", {})
	else:
		player.unhandled_input(event)

func physics_process(delta: float):
	player.physics_process(delta)

func process(_delta):
	player.facing_direction()
	state_check()

func state_check():
	
	if player.glide:
		_state_machine.transition_to("Jump_glide")
	elif abs(player.direction) < 0.01:
		_state_machine.transition_to("Idle", {})

func enter(_msg: Dictionary = {}):
	player.speed = player.max_run_speed
	animation.play("Run")
