extends BaseLevel

onready var gates 	= $Gates

func _ready():
	var _success = EventBus.connect("player_picked_up_item", self, "_on_key_item_collected") 
	
func _on_key_item_collected(item_name):
	if item_name == "HeartKeyItem":
		animationPlayer.queue("Gate_opening_cut_scene")
