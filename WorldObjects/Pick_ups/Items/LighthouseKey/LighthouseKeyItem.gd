extends PickupContainer

onready var pickup_collision_shape = $PickupArea2D/CollisionShape2D

func play_show_animation():
	viewScene.play_show_animation()
	pickup_collision_shape.disabled = false
