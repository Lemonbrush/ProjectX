extends BaseLevel

func _ready():
	var _success = EventBus.connect("player_picked_up_item", self, "_on_item_collected") 
	
func _on_item_collected(item_name):
	if item_name == "LeftSideHeartItem":
		animationPlayer.queue("First_torch_ignite_cutscene")
