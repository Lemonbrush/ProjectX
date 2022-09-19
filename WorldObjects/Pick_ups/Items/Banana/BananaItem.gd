extends PickupContainer

export(float) var pickup_wait_time = 0

onready var hazardArea = $HazardArea
onready var hazardCollisionShape = $HazardArea/CollisionShape2D
onready var pickupCollisionShape = $PickupArea2D/CollisionShape2D
onready var unpickable_timer = $UnpickableTimer

func _ready():
	hazardArea.connect("area_entered", self, "hit_has_been_landed")

func hit_has_been_landed(_body):
	hazardCollisionShape.set_deferred("disabled", true)
	gravity_scale = 2
	
	apply_impulse(Vector2.ZERO, Vector2(0, -50))
	
	if viewScene != null && viewScene.has_method("play_dropped_animation"):
		viewScene.play_dropped_animation()
	
	unpickable_timer.wait_time = pickup_wait_time
	var _connect = unpickable_timer.connect("timeout", self, "_pickable_timer_handle")
	unpickable_timer.call_deferred("start")

func _pickable_timer_handle():
	pickupCollisionShape.set_deferred("disabled", false)
