extends Node2D

export (int) var amount = 1

var kissie_object = preload("res://Project/WorldObjects/Pick_ups/Kissies/Kissie.tscn")

func _ready():
	pass

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

func infinite_spawn():
	for n in rand_range(3, 10):
		spawn_kissie()
