extends BaseLevel

var playerScene = preload("res://Player/Player.tscn")

onready var player_spawn_position = $World_objects/PlayerSpawnPosition

func spawn_player():
	var playerInstance = playerScene.instance()
	get_parent().add_child(playerInstance)
	playerInstance.global_position = player_spawn_position.position
