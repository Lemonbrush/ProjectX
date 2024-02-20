extends Node2D

enum SpawnerType {
	RANDOM,
	PRECISE
}

export (int) var amount = 1
export (String) var spawner_id = "default_id"
export (SpawnerType) var spawner_type = SpawnerType.RANDOM

var kissie_object = preload("res://Project/WorldObjects/Pick_ups/Kissies/Kissie.tscn")

func _ready():
	var _connection = EventBus.connect("activate_kissies_spawner_with_spawner_id", self, "spawn_by_spawner_id")

func spawn_kissie():
	var kissie_instance = kissie_object.instance()
	get_tree().get_current_scene().call_deferred("add_child", kissie_instance)
	kissie_instance.set_position(global_position)
	
	if kissie_instance.has_method("start_pickup_timer"):
		kissie_instance.call_deferred("start_pickup_timer")
	
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
	match spawner_type:
		SpawnerType.RANDOM:
			_spawn_kissies_rand()
		SpawnerType.PRECISE:
			_spawn__precise_amount_of_kissies()

func _spawn_kissies_rand():
	for n in rand_range(3, 10):
		spawn_kissie()

func _spawn__precise_amount_of_kissies():
	for n in amount:
		spawn_kissie()
