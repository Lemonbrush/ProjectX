extends Barrel

signal cork_destroyed

func destruct(_area = null):
	.destruct()
	emit_signal("cork_destroyed")
