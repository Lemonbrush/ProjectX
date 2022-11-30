extends Node2D

onready var tween = $IslandLiftTween
onready var guardianStatue = $Background_world_objects/Guardian_statue

var topPosition = Vector2(103, -724)
var middlePosition = Vector2(103, -180)
var bottomPosition = Vector2(103, 85)

func _ready():
	var _lift_up_connection = guardianStatue.connect("lift_island_with_direction_up", self, "lift_island")

func lift_island(direction_up):
	var destination_position = topPosition if direction_up else bottomPosition
	tween.interpolate_property(self, "position", position, destination_position, 15, Tween.TRANS_LINEAR, Tween.TRANS_LINEAR)
	tween.start()
