extends PickupContainer

onready var collisionShape = $PickupArea2D/CollisionShape2D

func drop():
	collisionShape.disabled = true
	apply_impulse(Vector2(0, 0), Vector2(0, -150))
	
	var timer = Timer.new()
	var _connect = timer.connect("timeout", self, "_pickable_timer_handle")
	timer.wait_time = 1
	timer.one_shot = true
	add_child(timer)
	timer.start()
	
	timer.call_deferred("start")

func _pickable_timer_handle():
	collisionShape.disabled = false
