extends Node2D

onready var tween = $IslandLiftTween

var topPosition = Vector2(103, -724)
var middlePosition = Vector2(103, -180)
var bottomPosition = Vector2(103, 85)

func _ready():
	var _lift_up_connection = EventBus.connect("guardian_statue_lift_up", self, "guardian_statue_lift_up")
	var _lift_down_connection = EventBus.connect("guardian_statue_lift_down", self, "guardian_statue_lift_down") 

func guardian_statue_lift_up():
	tween.interpolate_property(self, "position", position, topPosition, 15, Tween.TRANS_LINEAR, Tween.TRANS_LINEAR)
	tween.start()

func guardian_statue_lift_down():
	tween.interpolate_property(self, "position", position, bottomPosition, 15, Tween.TRANS_LINEAR, Tween.TRANS_LINEAR)
	tween.start()
