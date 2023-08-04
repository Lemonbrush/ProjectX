extends Area2D

signal level_turned()

export(int) var link_code = 0

onready var actionables_container: Node2D = get_parent().get_node("actionables")
onready var sprite = get_node("Sprite")

func _ready():
	if link_code != 0:
		for actionable in actionables_container.get_children():
			if actionable.link_code == link_code:
				connect("lever_turned", actionable, "_change_state")
