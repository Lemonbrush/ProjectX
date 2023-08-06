extends Node2D

onready var lamp_buth_turned_on = $Lamp_buth_turned_on
onready var lamp_buth_turned_off = $Lamp_buth_turned_off

func _ready():
	var lamp_ignited_const = GameEventConstants.get_constant("player_ignited_lighthouse_lamp")
	if lamp_ignited_const == null:
		return
	lamp_buth_turned_off.visible = !lamp_ignited_const
	lamp_buth_turned_on.visible = lamp_ignited_const
