extends BaseLevel

var playerScene = preload("res://Player/Player.tscn")

onready var player_spawn_position = $World_objects/PlayerSpawnPosition
onready var portal_interaction_object = $World_objects/PortalInteractionEmitter
onready var sofa_entering_portal_animation_player = $AnimationPlayer/SofaEnteringPortalAnimationPlayer

func _ready():
	var _connection = portal_interaction_object.connect("interacted_with_arg", self, "player_interacted_with_portal")

func player_interacted_with_portal(_args):
	sofa_entering_portal_animation_player.play("Animate")

func spawn_player():
	var playerInstance = playerScene.instance()
	get_parent().add_child(playerInstance)
	playerInstance.global_position = player_spawn_position.position
