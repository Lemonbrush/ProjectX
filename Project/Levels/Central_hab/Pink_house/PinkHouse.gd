extends BaseLevel

onready var dwellers= $Dwellers

func _ready():
	if GameEventConstants.is_cauldron_quest_completed():
		dwellers.visible = true
