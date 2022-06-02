extends PickupContainer

func drop():
	$Area2D/CollisionShape2D.disabled = true
	apply_impulse(Vector2(0, 0), Vector2(0, -150))
	
	var _connect = $UnpickableTimer.connect("timeout", self, "_pickable_timer_handle")
	$UnpickableTimer.call_deferred("start")

func _pickable_timer_handle():
	$Area2D/CollisionShape2D.disabled = false
