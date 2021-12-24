extends PlayerState

var hit = false
var impulse = Vector2.ZERO
var deceleration = 0.0

func unhandled_input(event: InputEvent):
	if event.is_action_pressed("Attack"):
		hit = true
		_state_machine.transition_to("Attack")
	else:
		player.unhandled_input(event)

func physics_process(delta: float):
	velocity_logic(delta)
	gravity_logic(delta)
	player.collision_logic()
	player.ground_update_logic()
	
func velocity_logic(delta):
	player.velocity = player.velocity.move_toward(Vector2.ZERO, deceleration * delta)
	
func gravity_logic(delta):
	if !player.is_grounded:
		player.velocity.y += player.gravity * delta
	player.velocity.y = min(player.velocity.y, player.fall_limit)

func state_check(anim: String = ''):
	if player.is_grounded:
		_state_machine.transition_to("Idle", {})
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
	animation.play("Attack")
	set_impulse(120, 5 * 60)
	animation.connect("animation_finished", self, "state_check")
	
func exit():
	animation.disconnect("animation_finished", self, "state_check")
	
func set_impulse(imp, dcc):
	impulse.x = imp * player.body.scale.x
	deceleration = dcc
	
