extends RigidBody2D

onready var pickup_timer = $PickupTimer

const y_offset = 100

var flying_kissie_object = preload("res://Project/WorldObjects/Pick_ups/Kissies/Flying_kissie/FlyingKissie.tscn")

func _ready():
	pickup_timer.connect("timeout", self, "spawn_flying_kissies")

func start_pickup_timer():
	pickup_timer.start()

func spawn_flying_kissies():
	var flying_kissie_instance = flying_kissie_object.instance()
	get_tree().get_current_scene().call_deferred("add_child", flying_kissie_instance)
	flying_kissie_instance.set_position(global_position)
	
	queue_free()
