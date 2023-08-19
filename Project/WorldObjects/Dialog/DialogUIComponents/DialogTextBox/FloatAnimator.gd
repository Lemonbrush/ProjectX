extends Node2D

export(NodePath) var target_node_path

onready var floatTween = $Tween

var animation_duration = 2
var float_hight = 3
var float_animation_direction_up = false

func _ready():
	var _tween_connection = floatTween.connect("tween_completed", self, "floating_tween_finished")

func start():
	var new_y_position = 0
	if float_animation_direction_up:
		new_y_position = float_hight
	float_animation_direction_up = !float_animation_direction_up
	
	var target_node = get_node(target_node_path) 
	if target_node == null:
		return
	
	floatTween.stop(target_node)
	var old_y_position = target_node.position.y
	floatTween.interpolate_property(
		target_node,
		'position:y',
		old_y_position,
		new_y_position,
		animation_duration,
		Tween.TRANS_CUBIC,
		Tween.EASE_IN_OUT,
		0
		)
	floatTween.start()
	
func floating_tween_finished(_arg1, _arg2):
	start()
