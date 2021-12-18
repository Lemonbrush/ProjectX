extends State
class_name PlayerState

onready var player = owner
onready var animation: AnimationPlayer = owner.get_node("AnimationPlayer")

var next_state = {}
