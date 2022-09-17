extends PickupContainer

onready var hazardArea = $HazardArea
onready var hazardCollisionShape = $HazardArea/CollisionShape2D
onready var pickupCollisionShape = $PickupArea2D/CollisionShape2D

func _ready():
	hazardArea.connect("area_entered", self, "hit_has_been_landed")

func hit_has_been_landed(_body):
	pickupCollisionShape.set_deferred("disabled", false)
	hazardCollisionShape.set_deferred("disabled", true)
	gravity_scale = 2
	
	apply_impulse(Vector2.ZERO, Vector2(0, -50))
	
	if viewScene != null && viewScene.has_method("play_dropped_animation"):
		viewScene.play_dropped_animation()
