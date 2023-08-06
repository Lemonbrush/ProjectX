extends KinematicBody2D

export(String, FILE, "*.tscn, *scn") var crush_animation_scene

onready var hazard_area 			= $HazardArea

var velocity = Vector2.ZERO

func _ready():
	hazard_area.connect("area_entered", self, "destruct")
	
func _process(delta):
	velocity.y += 600 * delta
	velocity = move_and_slide(velocity, Vector2.UP)

func destruct(_area):
	var barrel_crush_instance = crush_animation_scene.instance()
	get_parent().add_child_below_node(self, barrel_crush_instance)
	barrel_crush_instance.global_position = global_position
	velocity = Vector2.ZERO
	queue_free()

func save():
	var save_dict = {
		"objectType" : "Destructable",
		"filename" : get_filename(),
		"parent" : get_parent().get_path(),
		"pos_x" : position.x, 
		"pos_y" : position.y,
		"z_index" : z_index
	}
	return save_dict
