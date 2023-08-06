extends Node2D

export (PackedScene) var  flyingBirdScene 

onready var animationPlayer = $AnimationPlayer
onready var squickTiner = $SquickTimer
onready var area2D = $Area2D
onready var collisionShape = $Area2D/CollisionShape2D

var should_hide = false

func _ready():
	var _area2DConnection = area2D.connect("body_entered", self, "bird_did_spooken")
	var _squick_connection = squickTiner.connect("timeout", self, "squick")
	
	reset_states()
	
func bird_did_spooken(_body):
	squickTiner.paused = true
	visible = false
	collisionShape.set_deferred("disabled", true)
	
	var flyingBirdInstance = flyingBirdScene.instance()
	flyingBirdInstance.position = position
	get_parent().add_child_below_node(self, flyingBirdInstance)

func squick():
	animationPlayer.play("Squick")

func reset_states():
	collisionShape.disabled = false
	visible = true
	animationPlayer.play("Idle")
	reset_squick_timer()

func reset_squick_timer():
	squickTiner.wait_time = rand_range(3, 10)
	squickTiner.start()
