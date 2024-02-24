extends BaseLevel

enum CutsceneStage {
	INITIAL_CUTSCENE,
	KISSING,
	PLAYING
}

onready var platform_approachDetector = $PlatformApproachDetector

onready var cutscene_interaction_emitter = $SkyIsland/Middle_world_objects/Cutscene_objects/CutsceneInteractionEmitterObject
onready var cutscene_dialog_manager = $SkyIsland/Middle_world_objects/Cutscene_objects/ProposalIndependantDialogController
onready var heartbeat_audioPlayer = $Audio/ProposalStage/HeartBeatAudioStreamPlayer
onready var proposal_control = $SkyIsland/ProposalControl
onready var cutscene_kissie_spawner = $SkyIsland/Middle_world_objects/Cutscene_objects/KissieCounter/CutsceneKissieSpawner

var game_menu_path = "res://Project/UI/Screens/GameMenu/GameMenu.tscn"

export (CutsceneStage) var cutscene_stage = CutsceneStage.INITIAL_CUTSCENE

func _ready():
	var _elevator_connection = platform_approachDetector.connect("player_did_enter_elevator", self, "player_did_enter_elevator")
	var _cutscene_interaction_emitter_connection = cutscene_interaction_emitter.connect("interacted_with_arg", self, "did_interact_with_cutscene_controller")
	var _proposal_stage = EventBus.connect("start_proposal_stage", self, "start_proposal_stage")
	var _yes_connect = proposal_control.connect("she_said_yes", self, "she_said_yes")
	var _no_connect = proposal_control.connect("she_said_no", self, "she_said_no")

func player_did_enter_elevator():
	animationPlayer.play("Elevation_cutscene")

func did_interact_with_cutscene_controller(_args):
	cutscene_stage = CutsceneStage.PLAYING
	animationPlayer.play("Awakening_cutscene_pt1")

func did_finish_awakening_cutscene_part():
	cutscene_stage = CutsceneStage.KISSING

func did_finish_kissing_cutscene_part():
	cutscene_stage = CutsceneStage.PLAYING

func start_proposal_stage():
	cutscene_dialog_manager.finish_dialog()
	animationPlayer.play("Start_proposal_stage")

func transition_to_main_menu():
	LevelManager.transition_to_scene(load(game_menu_path))

func she_said_no():
	heartbeat_audioPlayer.stop()
	LevelManager.transition_to_scene(load(game_menu_path))

func she_said_yes():
	heartbeat_audioPlayer.stop()
	animationPlayer.play("She_said_yes_cutscene")
