extends Node2D

export(NodePath) var interaction_controller_path
export var CHAR_READ_RATE = 0.02
export(String, MULTILINE) var text = ""

onready var textTween = $TextTween
onready var appearanceTween = $AppearanceTween
onready var label = $MarginNode/PanelContainer/MarginContainer/Label
onready var marginNode = $MarginNode


func _ready():
	modulate.a = 0.0
	var interaction_controller = get_node(interaction_controller_path) 
	interaction_controller.connect("on_leave", self, "_on_leave")
	interaction_controller.connect("on_interact", self, "_on_interact")
	
func add_text(next_text):
	label.text = next_text
	textTween.interpolate_property(label, "percent_visible", 0.0, 1.0, len(next_text) * CHAR_READ_RATE, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	textTween.start()

func show():
	if modulate.a != 1.0:
		add_text(text)
		marginNode.position.y = 10
		appearanceTween.stop(self)
		appearanceTween.interpolate_property(self, 'modulate:a', get_modulate().a, 1.0, 0.25, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0)
		appearanceTween.interpolate_property(marginNode, 'position:y', marginNode.position.y, 0.0, 0.25, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0)
		appearanceTween.start()

func hide():
	if modulate.a != 0.0:
		appearanceTween.stop(self)
		appearanceTween.interpolate_property(self, 'modulate:a', get_modulate().a, 0.0, 0.25, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0)
		appearanceTween.interpolate_property(marginNode, 'position:y', marginNode.position.y, -10, 0.25, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0)
		appearanceTween.start()
		
func _on_leave():
	hide()
	
func _on_interact():
	show()
