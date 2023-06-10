extends BaseLevel

onready var platform_approachDetector = $PlatformApproachDetector
onready var final_cutscene_start_interaction_emitter = $SkyIsland/Middle_world_objects/Me/InteractionEmitterObject

func _ready():
	var _elevator_connection = platform_approachDetector.connect("player_did_enter_elevator", self, "player_did_enter_elevator")
	var _final_cutscene_start_connection = final_cutscene_start_interaction_emitter.connect("interacted_with_arg", self, "did_start_final_cutscene")
	var _proposal_stage = EventBus.connect("start_proposal_stage", self, "start_proposal_stage")

func player_did_enter_elevator():
	animationPlayer.play("Elevation_cutscene")

func did_start_final_cutscene(_args):
	animationPlayer.play("Awakening_cutscene")

func start_proposal_stage():
	animationPlayer.play("Start_proposal_stage")
