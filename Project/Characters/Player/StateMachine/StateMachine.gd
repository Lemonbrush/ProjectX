extends Node
class_name StateMachine

signal transitioned(state)

export var initial_state = NodePath()

onready var state: State = get_node(initial_state) setget set_state
onready var current_state = state.name

var states: = {}

func set_state(value):
	state = value
	
# LifeCycle

func _init():
	add_to_group("state_machine")
	
func _ready():
	yield(owner, "ready")
	state.enter()

func _unhandled_input(event):
	state.unhandled_input(event)

func _process(delta):
	state.process(delta)

func _physics_process(delta):
	state.physics_process(delta)
		
# Functions

func transition_to_door_interaction_state_if_needed():
	if owner.is_entering_out:
		transition_to("Door_enter_out", {})
	if owner.entering_scene_path:
		transition_to("Door_enter_in", { next_scene = owner.entering_scene_path})
		owner.entering_scene_path = null

func transition_to(target_state: String, msg: Dictionary = {}):
	if !states.has(target_state):
		print("there is no state: ", target_state)
		return
	
	state.exit()
	
	set_state(states[target_state])
	current_state = target_state
	state.enter(msg)
	
	emit_signal("transitioned", target_state)
