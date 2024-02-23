extends Node2D

signal spawn_count_finished()
signal did_change_kissie_count(count)

export (String) var spawner_id = "default_id"
export (int) var kissie_count = 0

onready var timer = $Timer

var kissie_object = preload("res://Project/WorldObjects/Pick_ups/Kissies/Kissie.tscn")

func _ready():
	var _connection = EventBus.connect("activate_kissies_spawner_with_spawner_id", self, "spawn_by_spawner_id")
	var _timer_connection = timer.connect("timeout", self, "process_spawn_tick")

func process_spawn_tick():
	if kissie_count <= 0:
		timer.stop()
		emit_signal("spawn_count_finished")
		return
	
	spawn_kissie()
	kissie_count -= 1
	
	emit_signal("did_change_kissie_count", kissie_count)
	
	if timer.wait_time > 0.2:
		timer.wait_time -= 0.1
	
	timer.start()

func spawn_kissie():
	var kissie_instance = kissie_object.instance()
	get_tree().get_current_scene().call_deferred("add_child", kissie_instance)
	kissie_instance.set_position(global_position)
	kissie_instance.set_target_object_group_name("Me")
	kissie_instance.set_cutscene_mode(true)
	
	var impulse_offset_x = rand_range(100, -100)
	var impulse_offset_y = rand_range(-50, -250)
	kissie_instance.apply_impulse(
		Vector2.ZERO, 
		Vector2(impulse_offset_x, impulse_offset_y)
		)

func spawn_by_spawner_id(id):
	if spawner_id == id:
		start_spawn()

func start_spawn():
	var kissie_count_const = GameEventConstants.get_constant("kissies_count")
	if kissie_count_const != null:
		kissie_count = kissie_count_const
	
	timer.start()
