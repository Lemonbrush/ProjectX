extends NpcAction

export(int) var move_speed = 10
export(int) var target_x_position = 0

func _init():
	state = State.WALKING
