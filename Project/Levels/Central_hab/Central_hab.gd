extends BaseLevel

onready var lovers = $Middle_world_objects/Dwellers/Lovers

func _ready():
	var _connection = EventBus.connect("show_lighthouse_key", self, "show_lighthouse_key")
	var _lighthouse_quest_connection = EventBus.connect("lighthouse_mystic_dweller_finish_quest_cutscene", self, "lighthouse_mystic_dweller_finish_quest_cutscene")
	var _lower_volume_connection = lovers.connect("set_background_music_volume", self, "set_background_music_volumeDB")
	var _reset_volume_connection = lovers.connect("reset_background_music_volume", self, "reset_background_music_volumeDB")

func lighthouse_mystic_dweller_finish_quest_cutscene():
	animationPlayer.play("Lighthouse_mystic_dweller_finish_quest_cutscene")

func show_lighthouse_key():
	animationPlayer.queue("show_lighthouse_key_cut_scene")
