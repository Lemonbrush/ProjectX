extends KinematicBody2D

var barrel_crush_scene			= preload("res://WorldObjects/Destructables/Barrel/Barrel_crush/Barrel_crush.tscn")

onready var hazard_area 			= $HazardArea

var velocity 					= Vector2.ZERO

func _ready():
	hazard_area.connect("area_entered", self, "destruct")
	
func _process(delta):
	velocity.y += 600 * delta
	velocity = move_and_slide(velocity, Vector2.UP)

func destruct(_area):
	var barrel_crush_instance = barrel_crush_scene.instance()
	get_parent().add_child_below_node(self, barrel_crush_instance)
	barrel_crush_instance.global_position = global_position
	velocity = Vector2.ZERO
	queue_free()
