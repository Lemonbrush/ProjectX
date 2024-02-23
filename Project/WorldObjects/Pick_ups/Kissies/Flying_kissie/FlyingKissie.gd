extends Node2D

const SPEED = 250

export (String) var target_object_group_name = "Player"

onready var pickup_area = $Area2D
onready var kissie_view = $KissieView
var is_picking_up = false
var is_cutscene_kissie = false

func _ready():
	kissie_view.connect("did_finish_animation", self, "queue_free")

func _process(delta):
	var bodies_size = pickup_area.get_overlapping_bodies().size()
	if bodies_size > 0 and !is_picking_up:
		reached_player()
		is_picking_up = true
	else:
		var target_position = get_target_position()
		if target_position:
			position = position.move_toward(target_position, delta * SPEED)

func get_target_position():
	var nodes = get_tree().get_nodes_in_group(target_object_group_name)
	if nodes.size() < 1:
		return
	var target_position = nodes[0].global_position
	target_position.y = target_position.y - 10
	return target_position

func reached_player():
	if !is_cutscene_kissie:
		GameEventConstants.increment_kissie_counter()
	kissie_view.pickup()

func set_target_object_group_name(new_target_name):
	target_object_group_name = new_target_name

func set_cutscene_mode(is_cutscene):
	is_cutscene_kissie = is_cutscene
