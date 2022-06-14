extends PlayerState

var hit = false
var impulse = Vector2.ZERO
var deceleration = 0.0

func unhandled_input(event: InputEvent):
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

func state_check(_anim: String = ''):
	pass

func enter(_msg: Dictionary = {}):
	animation.play("Door_entering")
	var _connection = animation.connect("animation_finished", self, "state_check")
	
func exit():
	animation.disconnect("animation_finished", self, "state_check")
	
func door_entering_animation_finished():
	LevelManager.transition_to_level(nextLevelPath)
