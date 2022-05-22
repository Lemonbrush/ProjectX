extends Node2D

export(NodePath) var interaction_controller_path

onready var label = $MarginNode/CenterContainer/Label

export(String) var labelText = ""

func _ready():
	label.text = labelText
	label.visible = false
	var interaction_controller = get_node(interaction_controller_path) 
	interaction_controller.connect("on_approach", self, "_on_approach")
	interaction_controller.connect("on_leave", self, "_on_leave")
	interaction_controller.connect("on_interact", self, "_on_interact")
	
func show():
	label.visible = true

func hide():
	label.visible = false
	
func _on_approach():
	show()
	
func _on_leave():
	hide()
	
func _on_interact():
	hide()
