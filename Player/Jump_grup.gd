extends PlayerState

onready var cornerGrab = owner.get_node("CornerGrab")

var jump_top_trashold = 100.0
var is_jump_pressed = false

func unhandled_input(event: InputEvent):
	is_jump_pressed = event.is_action_pressed("jump")
	
	if event.is_action_pressed("Attack"):
		_state_machine.transition_to("Attack", {})
	else:
		player.unhandled_input(event)

func physics_process(delta: float):
	if player.solid_check == 0 && player.down <= 0.01:
		#cornerGrab.disabled = false
		cornerGrab.position.x = player.direction
	player.physics_process(delta)
	#cornerGrab.disabled = true

func process(_delta):
	player.facing_direction()

func state_check():
	if player.is_grounded:
		if abs(player.direction) < 0.01:
			_state_machine.transition_to("Idle")
		else:
			_state_machine.transition_to("Run")
	elif player.is_on_floor() && player.down < 0.01:
		if player.is_on_wall():
			_state_machine.transition_to("Hang")
	else:												# Not grounded
		if player.jump && !player.is_jumping && player.coyoteTimer.time_left > 0.0:
			player.velocity.y = player.jump_speed
			player.is_jumping = true
			player.coyoteTimer.stop()
			_state_machine.transition_to("Jump")
		else:
			return true
		
	return false

func enter(_msg: Dictionary = {}):
	player.speed = player.max_run_speed
	animation.play("Jump_simple")
