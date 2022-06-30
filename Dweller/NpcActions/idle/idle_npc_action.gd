extends NpcAction
class_name IdleNpcAction

export(float) var wait_time = 0
export(bool) var is_infinite = false

func _init():
	state = State.IDLE
