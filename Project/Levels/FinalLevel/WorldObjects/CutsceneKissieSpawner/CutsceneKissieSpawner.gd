extends Node2D

signal spawn_count_finished()
signal reached_power_level(number)
signal reached_second_power_level()
signal did_change_kissie_count(count)

var kissie_object = preload("res://Project/WorldObjects/Pick_ups/Kissies/Kissie.tscn")
var is_able_to_kiss_manually = false
var kissie_chank_count = 1
var kissie_count = 0
var first_power_level_threshhold: int = 0
var second_power_level_threshhold: int = 0
var third_power_level_threshhold: int = 0
var power_level = 0

func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("Interaction") and is_able_to_kiss_manually:
		for n in kissie_chank_count:
			process_spawn_tick()
		if kissie_chank_count <= 15:
			kissie_chank_count += 1

func process_spawn_tick():
	if kissie_count <= 0:
		is_able_to_kiss_manually = false
		emit_signal("spawn_count_finished")
		return
	spawn_kissie()
	kissie_count -= 1
	emit_signal("did_change_kissie_count", kissie_count)
	activate_power_up_animation_if_needed()

func start_spawn():
	var kissie_count_const = GameEventConstants.get_constant("kissies_count")
	if kissie_count_const == null:
		return
	
	kissie_count = kissie_count_const
	emit_signal("did_change_kissie_count", kissie_count)
	
	var threshhold_chunk = round(kissie_count/4)
	first_power_level_threshhold = kissie_count - threshhold_chunk
	second_power_level_threshhold = kissie_count - (threshhold_chunk*2)
	third_power_level_threshhold = kissie_count - (threshhold_chunk*3)
	
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

func activate_power_up_animation_if_needed():
	if kissie_count <= first_power_level_threshhold and power_level == 0:
		emit_signal("reached_power_level", 1)
		power_level = 1
	if kissie_count <= second_power_level_threshhold and power_level == 1:
		emit_signal("reached_power_level", 2)
		power_level = 2
	elif kissie_count <= third_power_level_threshhold and power_level == 2:
		emit_signal("reached_power_level", 3)
		power_level = 3

func set_manual_kissing(is_able):
	is_able_to_kiss_manually = is_able
