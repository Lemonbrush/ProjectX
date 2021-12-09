extends Area2D

# LifeCycle

func _ready():
	connect("body_exited", self, "on_body_exited")

# Functions

func on_body_exited(body):
	if (body.get_collision_layer_bit(1) && !get_parent().get_collision_mask_bit(1)):
		get_parent().set_collision_mask_bit(1, true)
