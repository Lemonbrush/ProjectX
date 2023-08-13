extends Node2D

export(NodePath) var target_node_path

onready var appearTween = $Tween

var target_node

func _ready():
	target_node = get_node(target_node_path)

func instant_show():
	target_node.modulate.a = 1.0

func instant_hide():
	target_node.modulate.a = 0.0

func show_if_needed():
	if target_node.modulate.a == 0.0:
		show()

func show():
	if target_node == null:
		return
	appearTween.stop(target_node)
	appearTween.interpolate_property(target_node, 'modulate:a', target_node.get_modulate().a, 1.0, 0.25, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0)
	appearTween.start()

func hide():
	if target_node == null || target_node.modulate.a == 0.0:
		return
	
	appearTween.stop(target_node)
	appearTween.interpolate_property(target_node, 'modulate:a', target_node.get_modulate().a, 0.0, 0.25, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0)
	appearTween.start()
