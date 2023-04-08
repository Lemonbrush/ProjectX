extends BaseLevel

func _ready():
	var _connection = EventBus.connect("show_heart_assembling_cutscene", self, "show_heart_assembling_cutscene") 
	
func show_heart_assembling_cutscene():
	print("!!!!")
