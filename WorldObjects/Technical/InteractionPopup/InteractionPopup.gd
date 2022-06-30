extends Node2D

export(NodePath) var interaction_controller_path

onready var marginNode = $MarginNode
onready var label = $MarginNode/CenterContainer/HBoxContainer/Label
onready var tween = $Tween

export(String) var labelText = ""

func _ready():
	modulate.a = 0.0
	label.text = labelText
	var interaction_controller = get_node(interaction_controller_path) 
	interaction_controller.connect("on_approach", self, "_on_approach")
	interaction_controller.connect("on_leave", self, "_on_leave")
	interaction_controller.connect("on_interact", self, "_on_interact")
	
func show():
	if modulate.a != 1.0:
		marginNode.position.y = 10
		tween.stop(self)
		tween.interpolate_property(self, 'modulate:a', get_modulate().a, 1.0, 0.25, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0)
		tween.interpolate_property(marginNode, 'position:y', marginNode.position.y, 0.0, 0.25, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0)
		tween.start()

func hide():
	if modulate.a != 0.0:
		tween.stop(self)
		tween.interpolate_property(self, 'modulate:a', get_modulate().a, 0.0, 0.25, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0)
		tween.interpolate_property(marginNode, 'position:y', marginNode.position.y, -10, 0.25, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0)
		tween.start()
	
func _on_approach():
	show()
	
func _on_leave():
	hide()
	
func _on_interact(_body):
	hide()
