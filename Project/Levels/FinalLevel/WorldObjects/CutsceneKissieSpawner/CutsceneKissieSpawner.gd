extends Node2D

signal spawn_count_finished()
signal did_change_kissie_count(count)

var kissie_count = 0
var is_able_to_kiss_manually = false
var kissie_object = preload("res://Project/WorldObjects/Pick_ups/Kissies/Kissie.tscn")
var kissie_chank_count = 1

func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("Interaction") and is_able_to_kiss_manually:
		for n in kissie_chank_count:
			process_spawn_tick()
		kissie_chank_count += 1

func process_spawn_tick():
	if kissie_count <= 0:
		is_able_to_kiss_manually = false
		emit_signal("spawn_count_finished")
		return
	spawn_kissie()
	kissie_count -= 1
	emit_signal("did_change_kissie_count", kissie_count)

func start_spawn():
	var kissie_count_const = GameEventConstants.get_constant("kissies_count")
	if kissie_count_const != null:
		kissie_count = kissie_count_const
		emit_signal("did_change_kissie_count", kissie_count)
	is_able_to_kiss_manually = true

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
