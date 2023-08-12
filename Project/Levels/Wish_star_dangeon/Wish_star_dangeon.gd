extends BaseLevel

onready var cutscene_torch = $Cave_objects/Middle_world_objects/Moving_platforms/Interactive_platforms/Interactive_platform_1/Wide_torch

func _ready():
	var _success = EventBus.connect("player_picked_up_item", self, "_on_item_collected") 
	
func _on_item_collected(item_name):
	if item_name == "LeftSideHeartItem" and !cutscene_torch.is_torch_activated:
		animationPlayer.queue("First_torch_ignite_cutscene")
		
	if item_name == "RightSideHeartItem":
		animationPlayer.queue("Platforms_lift_cutscene")
