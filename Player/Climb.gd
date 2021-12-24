extends PlayerState

var previous_direction
var vertical_move_direction = Vector2.ZERO

func unhandled_input(event: InputEvent):		
	player.unhandled_input(event)

func physics_process(delta: float):
	velocity_logic(delta)
	gravity_logic(delta)
	player.collision_logic()
	player.ground_update_logic()
	
func velocity_logic(_delta):
	get_move_direction()
	vertical_move_direction = vertical_move_direction.normalized() * player.climb_speed
	var new_velocity = Vector2(0, vertical_move_direction.y)
	vertical_move_direction = player.move_and_slide(new_velocity)
	
func gravity_logic(_delta):
	player.velocity.x = 0.0

func process(_delta):
	player.facing_direction()
	state_check()

func state_check():
	if !player.is_able_to_climb || player.is_grounded && player.down > 0.01:
		_state_machine.transition_to("Idle", {})
	elif player.jump && (vertical_move_direction.y == 0):
		_state_machine.transition_to("Jump")

func enter(_msg: Dictionary = {}):
	player.speed = player.max_run_speed
	player.velocity = Vector2.ZERO
	player.is_jumping = false
	player.is_climbing = true
	player.is_able_to_glide = false
	player.global_position.x = player.climbing_area_position_x
	vertical_move_direction = Vector2.ZERO
	animation.play("Ladder_climb")

func exit():
	player.up = 0.0
	player.down = 0.0
	
func get_move_direction():
	if Input.is_action_pressed("up"):
		vertical_move_direction.y -= Input.get_action_strength("up")
		animation.play()
	elif Input.is_action_just_released("up"):
		vertical_move_direction.y = 0.0
		animation.stop()
	elif Input.is_action_pressed("down"):
		animation.play()
		vertical_move_direction.y += Input.get_action_strength("down")
	elif Input.is_action_just_released("down"):
		animation.stop()
		vertical_move_direction.y = 0.0
