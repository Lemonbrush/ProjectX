extends Node2D

onready var pickup_area = $Area2D

const SPEED = 250

func _ready():
	pass

func _process(delta):
	position = position.move_toward(get_target_position(), delta * SPEED)
	
	if pickup_area.get_overlapping_bodies().size() > 0:
		reached_player()

func get_target_position():
	var nodes = get_tree().get_nodes_in_group("Player")
	if nodes.size() < 1:
		return
	var target_position = nodes[0].global_position
	target_position.y = target_position.y - 10
	return target_position

func reached_player():
	queue_free()
