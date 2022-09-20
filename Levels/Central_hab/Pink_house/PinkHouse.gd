extends BaseLevel

onready var dwellers= $Dwellers

func _ready():
	if GameEventConstants.is_cauldron_quest_completed():
		dynamic_camera = true
		camera.follow_player = dynamic_camera
		dwellers.visible = true
