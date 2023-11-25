extends Node2D

var start_level_scene_path = "res://Project/Levels/Start_gate_location/Start_gate_location.tscn"

func _ready():
	MusicPlayer.stop()

func transition_to_startlevel_scene():
	LevelManager.transition_to_level(start_level_scene_path)
