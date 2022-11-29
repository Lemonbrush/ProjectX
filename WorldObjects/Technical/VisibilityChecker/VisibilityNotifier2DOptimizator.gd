extends VisibilityNotifier2D

func _ready():
	var _show_connect = connect("screen_entered", get_parent(), "show")
	var _hide_connect = connect("screen_exited", get_parent(), "hide")
	get_parent().visible = false
