extends Node2D

signal dialogueFinished

export(NodePath) var interaction_controller_path
export var CHAR_READ_RATE = 0.02
export(Array, String, MULTILINE) var texts_array 

onready var textTween = $TextTween
onready var appearanceTween = $AppearanceTween
onready var label = $MarginNode/PanelContainer/MarginContainer/VBoxContainer/Label
onready var marginNode = $MarginNode
onready var buttonHint = $MarginNode/PanelContainer/ButtonHint

var current_text_show = 0

func _ready():
	buttonHint.modulate.a = 0.0
	modulate.a = 0.0
	var interaction_controller = get_node(interaction_controller_path) 
	interaction_controller.connect("on_leave", self, "_on_leave")
	interaction_controller.connect("on_interact", self, "_on_interact")
	
func add_text(next_text):
	label.text = next_text
	textTween.interpolate_property(label, "percent_visible", 0.0, 1.0, len(next_text) * CHAR_READ_RATE, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	textTween.start()

func hide():
	if modulate.a != 0.0:
		appearanceTween.stop(self)
		appearanceTween.interpolate_property(self, 'modulate:a', get_modulate().a, 0.0, 0.25, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0)
		appearanceTween.interpolate_property(marginNode, 'position:y', marginNode.position.y, -10, 0.25, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0)
		appearanceTween.start()

func show_next_text_portion():
	buttonHint.modulate.a = 0.0
	add_text(texts_array[current_text_show])
	marginNode.position.y = 10
	appearanceTween.stop(self)
	appearanceTween.interpolate_property(self, 'modulate:a', get_modulate().a, 1.0, 0.25, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0)
	appearanceTween.interpolate_property(buttonHint, 'modulate:a', buttonHint.get_modulate().a, 1.0, 0.25, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0.5)
	appearanceTween.interpolate_property(marginNode, 'position:y', marginNode.position.y, 0.0, 0.25, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0)
	appearanceTween.start()
		
func _on_leave():
	hide()
	current_text_show = 0
	
func _on_interact(_body):
	if current_text_show >= texts_array.size():
		hide()
		emit_signal("dialogueFinished")
		return
	
	show_next_text_portion()
	current_text_show += 1
