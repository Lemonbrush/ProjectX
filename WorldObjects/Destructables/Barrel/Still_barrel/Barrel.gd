extends KinematicBody2D

var barrel_crush_scene			= preload("res://WorldObjects/Destructables/Barrel/Barrel_crush/Barrel_crush.tscn")

onready var hazard_area 			= $HazardArea

var velocity 					= Vector2.ZERO

onready var ground_ray1 			= $GroundRay1
onready var ground_ray2 			= $GroundRay2
onready var ground_ray3 			= $GroundRay3
onready var ray_array			= [ground_ray1, ground_ray2, ground_ray3]

func _ready():
	
	hazard_area.connect("area_entered", self, "destruct")
	
func _process(delta):
	velocity.y += 600 * delta
	velocity = move_and_slide(velocity, Vector2.UP)
	check_ground()
	
func check_ground():
	for ray in ray_array:
		ray.force_raycast_update()
		if ray.is_colliding():
			destruct()

func destruct(_area = null):
	var barrel_crush_instance = barrel_crush_scene.instance()
	get_parent().add_child_below_node(self, barrel_crush_instance)
	barrel_crush_instance.global_position = global_position
	velocity = Vector2.ZERO
	queue_free()
