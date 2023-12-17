extends BaseLevel

export (bool) var is_able_to_skip_cutscene = true

onready var player_spawn_position = $World_objects/PlayerSpawnPosition
onready var portal_interaction_object = $World_objects/PortalInteractionEmitter
onready var sofa_entering_portal_animation_player = $AnimationPlayer/SofaEnteringPortalAnimationPlayer
onready var skip_hint_popup = $SkipHintInteractionPopup

var portal_sinking_animation_scene_path = "res://Project/Levels/Portal_sinking_cutscene/Portal_sinking_cutscene.tscn"
var start_gate_scene_path = "res://Project/Levels/Start_gate_location/Start_gate_location.tscn"
var playerScene = preload("res://Project/Characters/Player/Player.tscn")
var tempPlayer

func _ready():
	var _connection = portal_interaction_object.connect("interacted_with_arg", self, "player_interacted_with_portal")

func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("Interaction") && is_able_to_skip_cutscene:
		skip_hint_popup.hide()
		LevelManager.transition_to_level(start_gate_scene_path)

func player_interacted_with_portal(_args):
	sofa_entering_portal_animation_player.play("Animate")

func spawn_player():
	var playerInstance = playerScene.instance()
	add_child(playerInstance)
	tempPlayer = playerInstance
	playerInstance.global_position = player_spawn_position.position

func despawn_player():
	tempPlayer.queue_free()

func transition_to_portal_sinking_animation_scene():
	LevelManager.transition_to_level(portal_sinking_animation_scene_path)
