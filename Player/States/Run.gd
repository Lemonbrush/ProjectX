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
	if player.is_grounded || player.is_on_wall():
		if abs(player.direction) < 0.01:
			_state_machine.transition_to("Idle", {})
	else:
		if player.is_jumping && !player.is_gliding:
			if player.jump:
				_state_machine.transition_to("Jump")
		else:
			player.coyoteTimer.wait_time = player.jump_buffer
			player.coyoteTimer.start()
			
			var y = player.velocity.y
	
			if player.glide:
				_state_machine.transition_to("Jump_glide")
			elif abs(y) < player.jump_top_speed:
				_state_machine.transition_to("Jump_top", {})
			elif y > 0.0:
				_state_machine.transition_to("Jump_fall", {})
			elif y < 0.0:
				_state_machine.transition_to("Jump")

func enter(msg: Dictionary = {}):
	player.speed = player.max_run_speed
	
	if msg.has("do_stop_fall_animation"):
		animation.play("Land") 
		animation.queue("Run")
		player.spawnFootstepParticles(1.5)
	else:
		animation.play("Run")
