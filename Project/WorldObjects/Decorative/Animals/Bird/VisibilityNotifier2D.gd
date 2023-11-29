extends VisibilityNotifier2D

func _ready():
	var _show_connect = connect("screen_entered", get_parent(), "try_show_object")
	var _hide_connect = connect("screen_exited", get_parent(), "try_hide_object")
