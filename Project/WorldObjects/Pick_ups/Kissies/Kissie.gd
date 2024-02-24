extends RigidBody2D

enum Kissie_state {
	IDLE,
	FLYING,
	PICKING_UP
}

const y_offset = 100
const SPEED = 250

export (String) var target_object_group_name = "Player"
export (Kissie_state) var current_state = Kissie_state.IDLE

onready var pickup_timer = $PickupTimer
onready var pickup_area = $Area2D

var pickingup_kissie = preload("res://Project/WorldObjects/Pick_ups/Kissies/Kissie_pickup_animation/Kissie_pickup_animation.tscn")
var is_cutscene_kissie = false

func _ready():
	pickup_timer.connect("timeout", self, "pickup_timer_timeout")

func _process(delta):
	match current_state:
		Kissie_state.IDLE:
			process_idle_state()
		Kissie_state.FLYING:
			process_flying_state(delta)
		Kissie_state.PICKING_UP:
			process_picking_up_state()

func pickup_timer_timeout():
	current_state = Kissie_state.FLYING

func reached_player():
	current_state = Kissie_state.PICKING_UP

func set_target_object_group_name(new_target_name):
	target_object_group_name = new_target_name

func set_cutscene_mode(is_cutscene):
	is_cutscene_kissie = is_cutscene

func _get_target_position():
	var nodes = get_tree().get_nodes_in_group(target_object_group_name)
	if nodes.size() < 1:
		return
	var target_position = nodes[0].global_position
	target_position.y = target_position.y - 10
	return target_position

func process_flying_state(delta):
	if pickup_area.get_overlapping_bodies().size() > 0:
		reached_player()
	else:
		var target_position = _get_target_position()
		if target_position:
			position = position.move_toward(target_position, delta * SPEED)

func process_idle_state():
	pass

func spawn_kissie_pickup_animation():
	var pickingup_kissie_instance = pickingup_kissie.instance()
	get_tree().get_current_scene().call_deferred("add_child", pickingup_kissie_instance)
	pickingup_kissie_instance.set_position(global_position)

func process_picking_up_state():
	if !is_cutscene_kissie:
		GameEventConstants.increment_kissie_counter()
	spawn_kissie_pickup_animation()
	queue_free()
