extends KinematicBody2D
class_name Barrel

export (PackedScene) var crashAnimationScene
export (int) var weight = 600
export (bool) var background_object = false
export (PackedScene) var innerItemScene

onready var hazard_area 			= $HazardArea

var velocity 					= Vector2.ZERO

onready var ground_ray1 			= $GroundRay1
onready var ground_ray2 			= $GroundRay2
onready var ground_ray3 			= $GroundRay3
onready var ray_array			= [ground_ray1, ground_ray2, ground_ray3]

func _ready():
	hazard_area.connect("area_entered", self, "destruct")
	
func _process(delta):
	velocity.y += weight * delta
	velocity.x = 0
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if !background_object:
		check_ground()
	
func check_ground():
	for ray in ray_array:
		ray.force_raycast_update()
		if ray.is_colliding():
			destruct()

func destruct(_area = null):
	if crashAnimationScene != null:
		var crashAnimationSceneInstance = crashAnimationScene.instance()
		get_tree().get_current_scene().add_child(crashAnimationSceneInstance)
		crashAnimationSceneInstance.global_position = global_position
	
		drop_item()
	
		velocity = Vector2.ZERO
	queue_free()
	
func drop_item():
	if innerItemScene:
		var innerItemSceneInstance = innerItemScene.instance()
		innerItemSceneInstance.set_position(position)
		get_tree().get_current_scene().call_deferred("add_child", innerItemSceneInstance)
		if innerItemSceneInstance.has_method("drop"):
			innerItemSceneInstance.drop()
