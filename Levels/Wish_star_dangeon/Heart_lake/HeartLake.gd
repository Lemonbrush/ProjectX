extends BaseLevel

func _ready():
	var _connection = EventBus.connect("show_heart_assembling_cutscene", self, "show_heart_assembling_cutscene") 
	var _connection_disappear_cut = EventBus.connect("show_mystic_dweller_heart_assembler_disappear_cutscene", self, "show_mystic_dweller_heart_assembler_disappear_cutscene")
	
func show_heart_assembling_cutscene():
	GameEventConstants.set_constant("did_trigger_heart_assembling_cutscene", true)
	animationPlayer.play("Heart_assembling_cutscene")

func show_mystic_dweller_heart_assembler_disappear_cutscene():
	animationPlayer.play("Mystic_dweller_disappearance_cutscene")
