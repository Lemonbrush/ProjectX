extends Node2D

export (PackedScene) var  flyingBirdScene 

onready var animationPlayer = $AnimationPlayer
onready var squickTiner = $SquickTimer
onready var area2D = $Area2D
onready var collisionShape = $Area2D/CollisionShape2D
onready var visibilityNotifier = $VisibilityNotifier2D

var disappeared = false

func _ready():
	var _area2DConnection = area2D.connect("body_entered", self, "bird_did_spooken")
	var _squick_connection = squickTiner.connect("timeout", self, "squick")
	
	reset_states()
	
func bird_did_spooken(_body):
	squickTiner.paused = true
	collisionShape.set_deferred("disabled", true)
	disappeared = true
	animationPlayer.play("TakeOf")

func did_finish_take_off_animation():
	visible = false
	var flyingBirdInstance = flyingBirdScene.instance()
	flyingBirdInstance.position = position
	get_parent().add_child_below_node(self, flyingBirdInstance)

func squick():
	animationPlayer.play("Squick")

func try_hide_object():
	if disappeared:
		hide()

func try_show_object():
	if !disappeared:
		show()

func reset_states():
	disappeared = false
	collisionShape.disabled = false
	visible = true
	animationPlayer.play("Idle")
	reset_squick_timer()

func reset_squick_timer():
	squickTiner.wait_time = rand_range(3, 10)
	squickTiner.start()
