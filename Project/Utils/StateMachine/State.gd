extends Node
class_name State

onready var _state_machine = owner.get_node("StateMachine")
onready var parent = get_parent()

func _ready():
	_state_machine.states[name] = self
	
func unhandled_input(_event: InputEvent):
	pass
	
func process(_delta: float):
	pass
	
func physics_process(_delta: float):
	pass
	
func enter(_msg: = {}):
	pass

func exit():
	pass
