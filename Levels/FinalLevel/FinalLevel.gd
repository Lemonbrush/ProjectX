extends BaseLevel

onready var platform_approachDetector = $Tower/Middle_world_objects/PlatformApproachDetector

func _ready():
	var _elevator_connection = platform_approachDetector.connect("player_did_enter_elevator", self, "player_did_enter_elevator")

func player_did_enter_elevator():
	animationPlayer.play("Elevation_cutscene")
