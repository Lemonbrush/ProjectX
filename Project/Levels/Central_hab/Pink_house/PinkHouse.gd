extends BaseLevel

onready var dwellers= $Dwellers
onready var couchDweller = $Dwellers/CouchDweller
onready var stoolDweller = $Dwellers/StoolDweller

func _ready():
	var is_quest_compleated = GameEventConstants.is_cauldron_quest_completed()
	dwellers.visible = is_quest_compleated
	couchDweller.is_player_interaction_active = is_quest_compleated
	stoolDweller.is_player_interaction_active = is_quest_compleated
