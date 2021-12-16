extends KinematicBody2D
class_name Player

onready var ground_ray 			= $Body/GroundRay
onready var body 				= $Body
onready var solidCheck_area 	= $Body/SolidCheck
onready var coyoteTimer 		= $CoyoteTimer

signal died

const SNAP 						= 4.0
const NO_SNAP 					= 0

var is_ray_ground_detected 		= false

var snap						= Vector2.ZERO

var gravity 					= 700
var velocity 					= Vector2.ZERO
var speed						= 0.0

var current_speed 				= 0.0
var max_run_speed 				= 130
var run_acceleration 			= 500

var solid_check        			= 0

var jump_speed 					= -210
var jump_release				= jump_speed * 0.2
var jumpTerminationMultiplier	= 3
var jump_top_speed				= 500

var normal_fall 				= 700
var attack_fall 				= normal_fall * 1.2
var fall_limit 					= normal_fall

var direction					= 0.0
var left						= 0.0
var right						= 0.0
var up							= 0.0
var down						= 0.0
var jump						= false

var is_grounded					= false
var is_jumping 					= false
var isPassingThrough 			= false
var isStateNew 					= true

var isDying 					= false

############################## Lifecycle Functions ##############################

func _ready():
	solidCheck_area.connect("area_entered", self, "on_corner_grab_body_entered")
	solidCheck_area.connect("area_exited", self, "on_corner_grab_body_exited")
	
############################## State Machine Functions ##############################

func physics_process(delta):
	velocity_logic(delta)
	gravity_logic(delta)
	collision_logic()
	ground_update_logic()

############################## Functions ##############################

func velocity_logic(delta):
	var moveVector = Vector2(direction * speed, velocity.y)
	velocity = velocity.move_toward(moveVector, run_acceleration * delta)

func gravity_logic(delta):
	if is_grounded:
		if is_jumping:
			jump = false
			is_jumping = false
			snap.y = SNAP
		elif jump && down < 0.01:
			velocity.y = jump_speed
			is_jumping = true
			is_grounded = false
			snap.y = SNAP
	else:
		if is_jumping:
			if !jump:
				is_jumping = false
				if velocity.y < jump_release:
					velocity.y = jump_release
			else:
				velocity.y += gravity * delta
		else:
			velocity.y += gravity * delta
	
	velocity.y = min(velocity.y, fall_limit)
		
func collision_logic():
	velocity = move_and_slide(velocity, Vector2.UP)
	
func ground_update_logic():
	ray_ground_update()
	if is_grounded:
		if !is_on_floor() || !is_ray_ground_detected:
			is_grounded = false
			snap.y = NO_SNAP
	else:
		if is_on_floor() && is_ray_ground_detected:
			is_grounded = true
			snap.y = SNAP
	
func unhandled_input(event: InputEvent):
	if event.is_action_pressed("right") && right <= 0.01:
		right = event.get_action_strength("right")
		direction += right
	elif event.is_action_released("right"):
		direction -= right
		right = 0.0
	elif event.is_action_pressed("left") && left <= 0.01:
		left = event.get_action_strength("left")
		direction -= left
	elif event.is_action_released("left"):
		direction += left
		left = 0.0
	elif event.is_action_pressed("up") && up <= 0.01:
		up = event.get_action_strength("up")
	elif event.is_action_released("up"):
		up = 0.0
	elif event.is_action_pressed("down") && down <= 0.01:
		down = event.get_action_strength("down")
	elif event.is_action_released("down"):
		down = 0.0
		position.y += 1
	elif event.is_action_pressed("jump") && !jump:
		jump = true
	elif event.is_action_released("jump"):
		jump = false

func check_for_deadly_height():
	if (global_position.y > 1000):
			emit_signal("died")

func check_pass_trough_collision():
	if (Input.is_action_just_pressed("down") && $GroundRay.is_colliding()):
		position = Vector2(position.x, position.y + 1)
		
############################## Actions ##############################

func on_corner_grab_body_entered(_body):
	solid_check += 1

func on_corner_grab_body_exited(_body):
	solid_check -= 1
	
############################## Helper Functions ##############################

func ray_ground_update():
	ground_ray.force_raycast_update()
	is_ray_ground_detected = ground_ray.is_colliding()

func facing_direction():
	if abs(direction) > 0.0:
		body.scale.x = sign(direction)
