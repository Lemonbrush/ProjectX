extends Node2D

signal lift_island_with_direction_up(direction_up)

onready var animationPlayer = $AnimationPlayer
onready var dialogController = $DialogController

var lift_direction_up = true

func _ready():
	var _lift_up_connection = EventBus.connect("guardian_statue_lift_up", self, "guardian_statue_lift_up")
	var _lift_down_connection = EventBus.connect("guardian_statue_lift_down", self, "guardian_statue_lift_down")
	var _secret_connection = EventBus.connect("did_figure_out_guardian_secret", self, "did_figure_out_guardian_secret")
	configure_constants()

func guardian_statue_lift_up():
	lift_direction_up = true
	animationPlayer.play("Act")

func guardian_statue_lift_down():
	lift_direction_up = false
	animationPlayer.play("Act")

func did_figure_out_guardian_secret():
	configure_constants()

func lift_island():
	emit_signal("lift_island_with_direction_up", lift_direction_up)

func configure_constants():
	var did_say_where_special_flower_is_constant = GameEventConstants.get_constant("did_say_where_special_flower_is")
	dialogController.set_player_interaction(did_say_where_special_flower_is_constant)
