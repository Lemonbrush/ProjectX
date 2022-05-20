extends BaseLevel

onready var animationPlayer		= $AnimationPlayer
onready var gates 	= $Gates

func _ready():
	var page_collectable = find_node("Page")
	if page_collectable:
		page_collectable.connect("page_collected", self, "on_page_collected") 
	
func on_page_collected():
	animationPlayer.play("Gate_opening_cut_scene")
