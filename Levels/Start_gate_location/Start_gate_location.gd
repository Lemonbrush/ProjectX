extends BaseLevel

onready var gates 	= $Gates

func _ready():
	var page_collectable = find_node("Page")
	if page_collectable:
		page_collectable.connect("item_collected", self, "on_page_collected") 
	
func on_page_collected():
	animationPlayer.queue("Gate_opening_cut_scene")
