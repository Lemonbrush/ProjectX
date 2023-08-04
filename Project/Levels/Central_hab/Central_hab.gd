extends BaseLevel

func _ready():
	var _connection = EventBus.connect("show_lighthouse_key", self, "show_lighthouse_key")
	var _lighthouse_quest_connection = EventBus.connect("lighthouse_mystic_dweller_finish_quest_cutscene", self, "lighthouse_mystic_dweller_finish_quest_cutscene")

func lighthouse_mystic_dweller_finish_quest_cutscene():
	animationPlayer.play("Lighthouse_mystic_dweller_finish_quest_cutscene")

func show_lighthouse_key():
	animationPlayer.queue("show_lighthouse_key_cut_scene")
