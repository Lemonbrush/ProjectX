extends Node2D

signal lift_island_with_direction_up(direction_up)

onready var animationPlayer = $AnimationPlayer

var lift_direction_up = true

func _ready():
	var _lift_up_connection = EventBus.connect("guardian_statue_lift_up", self, "guardian_statue_lift_up")
	var _lift_down_connection = EventBus.connect("guardian_statue_lift_down", self, "guardian_statue_lift_down") 

func guardian_statue_lift_up():
	lift_direction_up = true
	animationPlayer.play("Act")

func guardian_statue_lift_down():
	lift_direction_up = false
	animationPlayer.play("Act")

func lift_island():
	emit_signal("lift_island_with_direction_up", lift_direction_up)
