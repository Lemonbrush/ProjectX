extends Control

onready var kissie_spawner = $CutsceneKissieSpawner
onready var label = $Label
onready var animation_player = $AnimationPlayer

func _ready():
	var _spawner_connection = kissie_spawner.connect("did_change_kissie_count", self, "update_kissie_count")
	var _set_spawner_connection = kissie_spawner.connect("set_kissie_count", self, "set_kissie_count")

func update_kissie_count(new_count):
	set_kissie_count(new_count)
	animation_player.play("Spawn_impact")

func set_kissie_count(new_count):
	label.text = str(new_count)
