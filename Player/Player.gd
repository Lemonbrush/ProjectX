extends KinematicBody2D
class_name Player

var footstepParticles = preload("res://Scenes/FootstepsParticles/FootstepParticles.tscn")

onready var ground_ray1 			= $Body/GroundRay1
onready var ground_ray2 			= $Body/GroundRay2
onready var ground_ray3 			= $Body/GroundRay3
onready var ray_array			= [ground_ray1, ground_ray2, ground_ray3]

onready var climb_area			= $Body/ClimbArea
onready var glider_area			= $Body/Glider
onready var attack_area			= $Body/AttackArea/CollisionShape2D

onready var body 				= $Body
onready var coyoteTimer 			= $CoyoteTimer

signal died

const SNAP 						= 4.0
const NO_SNAP 					= 0

var is_ray_ground_detected 		= false

var snap							= Vector2.ZERO

var gravity 						= 700
var velocity 					= Vector2.ZERO
var speed						= 0.0

var current_speed 				= 0.0
var max_run_speed 				= 130
var run_acceleration 			= 500
var climb_speed					= 50
var y_velocity_boost				= 0.0

var solid_check        			= 0

var is_able_to_climb				= false
var climbing_area_position_x		= 0.0

var jump_buffer					= 0.5
var jump_speed 					= -210
var jump_release					= jump_speed * 0.2
var jumpTerminationMultiplier	= 3
var jump_top_speed				= 100
var jump_glide_speed				= 50
var is_gliding					= false

var normal_fall 					= 300
var attack_fall 					= normal_fall * 1.2
var fall_limit 					= normal_fall

var direction					= 0.0
var left							= 0.0
var right						= 0.0
var up							= 0.0
var down							= 0.0
var jump							= false
var glide						= false
var is_able_to_glide				= false

var is_climbing					= false
var is_grounded					= false
var is_jumping 					= false
var is_dying 					= false

############################## Lifecycle Functions ##############################

func _ready():
	climb_area.connect("area_entered", self, "on_climb_area_entered")
	climb_area.connect("area_exited", self, "on_climb_area_exited")
	
	glider_area.connect("area_entered", self, "on_glide_area_entered")
	glider_area.connect("area_exited", self, "on_glide_area_exited")
	
############################## State Machine Functions ##############################

func physics_process(delta):
	velocity_logic(delta)
	gravity_logic(delta)
	collision_logic()
	ground_update_logic()
	checkForActionRelease()
	
############################## Functions ##############################

func velocity_logic(delta):
	var moveVector = Vector2(direction * speed, velocity.y)
	print(velocity)
	velocity = velocity.move_toward(moveVector, run_acceleration * delta)

func gravity_logic(delta):
	if is_climbing && jump:
		velocity.y = jump_speed
		is_jumping = true
		is_able_to_glide = false
		is_grounded = false
		snap.y = NO_SNAP
	elif is_grounded:
		glide = false
		is_able_to_glide = false
		
		if is_jumping:
			jump = false
			is_able_to_glide = false
			is_jumping = false
			snap.y = SNAP
		elif jump && down < 0.01:
			velocity.y = jump_speed
			is_jumping = true
			is_able_to_glide = false
			is_grounded = false
			snap.y = NO_SNAP
	else:
		if glide:
			if velocity.y < 0:
				velocity.y = 0
			velocity.y += (jump_glide_speed - y_velocity_boost) * delta
		elif is_jumping:
			if !jump:
				is_jumping = false
				if velocity.y < jump_release:
					velocity.y = jump_release
			else:
				velocity.y += gravity * delta
		else:
			velocity.y += gravity * delta
	
	is_climbing = false
		
	var non_zero_gravity = velocity.y if velocity.y != 0 else 1
	velocity.y = min(non_zero_gravity, fall_limit)
		
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
	elif event.is_action_pressed("left") && left <= 0.01:
		left = event.get_action_strength("left")
		direction -= left
	elif event.is_action_pressed("up") && up <= 0.01:
		up = event.get_action_strength("up")
		
		if is_able_to_climb:
			is_climbing = true
	elif event.is_action_pressed("down") && down <= 0.01:
		down = event.get_action_strength("down")
		position.y += 1
	elif event.is_action_pressed("jump"):
		if is_able_to_glide:
			 glide = true
		if !jump && !is_able_to_glide:
			jump = true
			#print("is_able_to_glide")
		else:
			glide = true

func check_for_deadly_height():
	if global_position.y > 1000:
		emit_signal("died")

func check_pass_trough_collision():
	if Input.is_action_just_pressed("down") && $GroundRay.is_colliding():
		position = Vector2(position.x, position.y + 1)
		
func checkForActionRelease():
	if !Input.is_action_pressed("right"):
		direction -= right
		right = 0.0
	
	if !Input.is_action_pressed("left"):
		direction += left
		left = 0.0
	
	if !Input.is_action_pressed("up"):
		up = 0.0
	
	if !Input.is_action_pressed("down"):
		down = 0.0
	
	if !Input.is_action_pressed("jump"):
		jump = false
		
		if is_jumping && !glide:
			is_able_to_glide = true
		else:
			glide = false
############################## Actions #######################################

func on_climb_area_entered(area):
	is_able_to_climb = true
	climbing_area_position_x = area.global_position.x
	
func on_climb_area_exited(_area):
	is_able_to_climb = false
	
func on_glide_area_entered(_area):
	y_velocity_boost = 6000
	
func on_glide_area_exited(_area):
	y_velocity_boost = 0.0
	
func activate_attack_area():
	attack_area.disabled = false

func disable_attack_area():
	attack_area.disabled = true

############################## Helper Functions ##############################

func ray_ground_update():
	var is_colliding = false
	
	for ray in ray_array:
		ray.force_raycast_update()
		if ray.is_colliding():
			is_colliding = true
	
	is_ray_ground_detected = is_colliding

func facing_direction():
	if abs(direction) > 0.0:
		body.scale.x = sign(direction)
		
func spawnFootstepParticles(scale = 1):
	var footstep = footstepParticles.instance()
	get_parent().add_child(footstep)
	footstep.scale = Vector2.ONE * scale
	footstep.global_position = global_position

func pause_level():
	get_tree().paused = true 
	
func unpouse_level():
	get_tree().paused = false
