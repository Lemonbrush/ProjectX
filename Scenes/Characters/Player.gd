extends KinematicBody2D

signal died

enum State { NORMAL, INPUT_DISABLED }

var gravity = 500
var velocity = Vector2.ZERO

var maxHorizontalSpeed = 150
var horizontalAcceleration = 500

var jumpSpeed = 200
var jumpTerminationMultiplier = 3

var currentState = State.NORMAL
var isStateNew = true

var isDying = false

# Lifecycle Functions

func _ready():
	pass

func _process(delta):
	match currentState:
		State.NORMAL:
			process_normal(delta)
	
# State Machine Functions 

func process_normal(delta):
	check_pass_trough_collision()
	
	var moveVector = get_movement_vector()
	velocity.x += moveVector.x * horizontalAcceleration * delta
	
	if (moveVector.x == 0):
		velocity.x = lerp(0, velocity.x, pow(2, -20 * delta))
		
	velocity.x = clamp(velocity.x, -maxHorizontalSpeed, maxHorizontalSpeed)
	
	# check if jump button pressed
	if (moveVector.y < 0 && is_on_floor()):
		velocity.y = moveVector.y * jumpSpeed
	
	if (velocity.y < 0 && !Input.is_action_pressed("jump")):
		velocity.y += gravity * jumpTerminationMultiplier * delta
	else:
		velocity.y += gravity * delta
	
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if (global_position.y > 1000):
		emit_signal("died")
	
	update_animation()
	
# Functions

func update_animation():
	var moveVector = get_movement_vector()
	
	if (!is_on_floor()):
		pass
	elif (moveVector.x != 0):
		$AnimatedSprite.play("run")
	else:
		$AnimatedSprite.play("idle")
		
	if (moveVector.x != 0):
		$AnimatedSprite.flip_h = true if moveVector.x < 0 else false

func check_pass_trough_collision():
	if (has_node("PassTroughArea") && Input.is_action_pressed("down")):
		set_collision_mask_bit(1, false)

func get_movement_vector():
	var moveVector = Vector2.ZERO
	moveVector.x = Input.get_action_raw_strength("right") - Input.get_action_raw_strength("left")
	moveVector.y = -1 if Input.is_action_just_pressed("jump") else 0
	
	return moveVector

# Helper Functions
