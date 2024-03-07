extends Node2D


export (String) var spawner_id = "default_id"

var kissie_object = preload("res://Project/WorldObjects/Pick_ups/Kissies/Kissie.tscn")

func _ready():
	var _connection = EventBus.connect("activate_kissies_spawner_with_spawner_id", self, "spawn_by_spawner_id")

func spawn_kissie():
	var kissie_instance = kissie_object.instance()
	get_tree().get_current_scene().call_deferred("add_child", kissie_instance)
	kissie_instance.set_position(global_position)
	kissie_instance.set_target_object_group_name("Me")
	
	var impulse_offset_x = rand_range(100, -100)
	var impulse_offset_y = rand_range(-100, -250)
	kissie_instance.apply_impulse(
		Vector2.ZERO, 
		Vector2(impulse_offset_x, impulse_offset_y)
		)

func spawn_by_spawner_id(id):
	if spawner_id == id:
		spawn()

func spawn():
	pass
