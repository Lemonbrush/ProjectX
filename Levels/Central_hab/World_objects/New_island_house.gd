extends Node2D

func _ready():
	var should_show_island = GameEventConstants.get_constant("did_finish_lighthouse_quest")
	if should_show_island != null:
		visible = should_show_island

func activate_island_const():
	GameEventConstants.set_constant("did_finish_lighthouse_quest", true)
