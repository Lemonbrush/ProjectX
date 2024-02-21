extends Node2D

const SPEED = 250

onready var pickup_area = $Area2D
onready var kissie_view = $KissieView
var is_picking_up = false

func _ready():
	kissie_view.connect("did_finish_animation", self, "queue_free")

func _process(delta):
	if pickup_area.get_overlapping_bodies().size() > 0 and !is_picking_up:
		reached_player()
		is_picking_up = true
	else:
		position = position.move_toward(get_target_position(), delta * SPEED)

func get_target_position():
	var nodes = get_tree().get_nodes_in_group("Player")
	if nodes.size() < 1:
		return
	var target_position = nodes[0].global_position
	target_position.y = target_position.y - 10
	return target_position

func reached_player():
	GameEventConstants.increment_kissie_counter()
	kissie_view.pickup()
