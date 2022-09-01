extends KinematicBody2D
class_name Player

var footstepParticles   = preload("res://WorldObjects/Technical/FootstepsParticles/FootstepParticles.tscn")
var appearParticles     = preload("res://WorldObjects/Technical/PlayerAppearParticles/PlayerAppearParticles.tscn")
var itemPickupScenePath = preload("res://Player/Animation_scenes/Item_picking_player/Item_picking_player.tscn")

onready var ground_ray1 			= $Body/GroundRay1
onready var ground_ray2 			= $Body/GroundRay2
onready var ground_ray3 			= $Body/GroundRay3
onready var ray_array			= [ground_ray1, ground_ray2, ground_ray3]

onready var climb_area			= $Body/ClimbArea
onready var glider_area			= $Body/Glider
onready var attack_area			= $Body/AttackArea
onready var hazard_area			= $Body/HazardArea
onready var attack_area_collision_shape = $Body/AttackArea/CollisionShape2D

onready var body 				= $Body
onready var coyoteTimer 			= $CoyoteTimer

signal died

const SNAP 						= 4.0
const NO_SNAP 					= 0

export(Vector2) var respawn_position				
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

var is_in_water					= true
var is_able_to_climb				= false
var climbing_area_position_x		= 0.0

var jump_buffer					= 0.5
var jump_speed 					= -210
var jump_release					= jump_speed * 0.2
var jumpTerminationMultiplier	= 3
var jump_top_speed				= 100
var jump_glide_speed				= 50
var is_gliding					= false
var glide_max_speed				= 100

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
var glide_area_count				= 0

var is_climbing					= false
var is_grounded					= false
var is_jumping 					= false
var is_dying 					= false

var entering_scene_path			= null
var is_entering_out 				= false	

############################## Lifecycle Functions ##############################

func _ready():
	climb_area.connect("area_entered", self, "on_climb_area_entered")
	climb_area.connect("area_exited", self, "on_climb_area_exited")
	
	glider_area.connect("area_entered", self, "on_glide_area_entered")
	glider_area.connect("area_exited", self, "on_glide_area_exited")
	
	attack_area.connect("area_entered", self, "on_attack_area_entered")
	hazard_area.connect("area_entered", self, "on_hazard_entered")
	
	var _connection = EventBus.connect("player_entered_door", self, "start_door_entering_animation")
	
############################## State Machine Functions ##############################

func physics_process(delta):
	velocity_logic(delta)
	gravity_logic(delta)
	collision_logic()
	ground_update_logic()
	check_for_action_release()
	
############################## Functions ##############################

func velocity_logic(delta):
	var moveVector = Vector2(direction * speed, velocity.y)
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
		is_able_to_glide = true
		if glide:
			if velocity.y < 0:
				velocity.y = 0
			
			if velocity.y > glide_max_speed:
				velocity.y = glide_max_speed
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
			respawn_position = global_position
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
		else:
			glide = true

func check_for_deadly_height():
	if global_position.y > 1000:
		emit_signal("died")

func check_pass_trough_collision():
	if Input.is_action_just_pressed("down") && $GroundRay.is_colliding():
		position = Vector2(position.x, position.y + 1)
		
func check_for_action_release():
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

# Climb
func on_climb_area_entered(area):
	is_able_to_climb = true
	climbing_area_position_x = area.global_position.x
	
func on_climb_area_exited(_area):
	is_able_to_climb = false
	
# Glide
func on_glide_area_entered(area):
	if area.get_name() == "water":
		is_in_water = true
	else:
		glide_area_count += 1
		y_velocity_boost = 6000
	
func on_glide_area_exited(area):
	if area.get_name() == "water":
		is_in_water = false
	
	glide_area_count -= 1
	
	if glide_area_count == 0:
		y_velocity_boost = 0
	
# Attack
func on_attack_area_entered(attacked_object):
	if attacked_object.has_method("change_state"):
		attacked_object.change_state()

func activate_attack_area():
	attack_area_collision_shape.disabled = false

func disable_attack_area():
	attack_area_collision_shape.disabled = true

# Hazard entered

func on_hazard_entered(_area):
	spawnAppearParticles()
	if respawn_position:
		global_position = respawn_position
	spawnAppearParticles()

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

func spawnAppearParticles():
	var particles = appearParticles.instance()
	get_parent().add_child(particles)
	particles.scale = Vector2.ONE * scale
	particles.global_position = global_position

func start_item_pickup_animation(itemScene):
	EventBus.player_animation_mode_change(true)
	
	var itemPickupScene = itemPickupScenePath.instance()
	itemPickupScene.itemScene = itemScene
	get_parent().add_child(itemPickupScene)
	itemPickupScene.global_position = global_position
	itemPickupScene.scale = Vector2.ONE * body.scale
	itemPickupScene.connect("animationFinished", self, "on_pickup_animation_finished")
	
	body.visible = false
	EventBus.camera_focuse_animation(Vector2(0.5, 0.5), 1)

func start_door_entering_animation(nextScenePath):
	entering_scene_path = nextScenePath
	
func on_pickup_animation_finished():
	EventBus.player_animation_mode_change(false)
	
	body.visible = true
	EventBus.camera_focuse_animation(Vector2(1, 1), 0.5)

func pause_level():
	get_tree().paused = true 
	
func unpouse_level():
	get_tree().paused = false
