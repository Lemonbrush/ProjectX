extends Node2D

signal did_finish_hide_animation()
signal did_finish_show_animation()

export(NodePath) var target_node_path

onready var showTween = $ShowTween
onready var hideTween = $HideTween

var target_node

func _ready():
	target_node = get_node(target_node_path)
	var _show_tween_connection = showTween.connect("tween_completed", self, "show_tween_finished")
	var _hide_tween_connection = hideTween.connect("tween_completed", self, "hide_tween_finished")

func instant_show():
	stop_all_tweens()
	target_node.modulate.a = 1.0

func instant_hide():
	stop_all_tweens()
	target_node.modulate.a = 0.0

func show():
	if target_node == null || target_node.modulate.a == 1.0:
		return
	stop_all_tweens()
	showTween.interpolate_property(target_node, 'modulate:a', target_node.get_modulate().a, 1.0, 0.25, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0)
	showTween.start()

func hide():
	if target_node == null || target_node.modulate.a == 0.0:
		return
	
	stop_all_tweens()
	hideTween.interpolate_property(target_node, 'modulate:a', target_node.get_modulate().a, 0.0, 0.25, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0)
	hideTween.start()

func hide_tween_finished(_param, _param_2):
	emit_signal("did_finish_hide_animation")

func show_tween_finished(_param, _param_2):
	emit_signal("did_finish_show_animation")

func stop_all_tweens():
	showTween.stop(target_node)
	hideTween.stop(target_node)
