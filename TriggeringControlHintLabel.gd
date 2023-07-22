extends Node2D

export var one_time_trigger = true
export var show_count = 0

onready var labelNodeController = $AppearingHintLabel
onready var triggerArea = $TriggerArea2D

func _ready():
	var _trigger_connect = triggerArea.connect("body_entered", self, "body_entered")

func body_entered(_body):
	if one_time_trigger && show_count > 0:
		return
	
	show_count += 1
	labelNodeController.show()
