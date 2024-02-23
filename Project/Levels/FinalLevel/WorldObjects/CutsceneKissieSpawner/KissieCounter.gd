extends Control

onready var kissie_spawner = $CutsceneKissieSpawner
onready var label = $Label
onready var animation_player = $AnimationPlayer

func _ready():
	var _spawner_connection = kissie_spawner.connect("did_change_kissie_count", self, "update_kissie_count")

func update_kissie_count(new_count):
	label.text = str(new_count)
	animation_player.play("Spawn_impact")
