extends Control

export (String) var text = ""

onready var label = $PanelContainer/MarginContainer/Label

func _ready():
	label.text = text
