extends BaseLevel

onready var gates 	= $Gates
onready var lonelyDweller = $WorldObjects/NPC/Dweller2

func _ready():
	var _success = EventBus.connect("player_picked_up_item", self, "_on_key_item_collected") 
	
	if GameEventConstants.is_cauldron_quest_completed():
		lonelyDweller.visible = false
	
func _on_key_item_collected(item_name):
	if item_name == "HeartKeyItem":
		animationPlayer.queue("Gate_opening_cut_scene")
