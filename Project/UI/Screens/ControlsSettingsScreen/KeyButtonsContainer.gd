extends VBoxContainer

export (NodePath) var scroll_container_path

func _ready():
	for child in get_children():
		child.connect("did_focus_entered", self, "_on_focus_change")

func _on_focus_change():
	var focused = get_focus_owner()
	var focus_offset = focused.rect_global_position.y
	print(focused.rect_global_position.y)
	var scroll_container = get_node(scroll_container_path)
	var scroll = scroll_container.get_v_scroll()
	var scrolled_bottom = scroll_container.get_rect().size.y - (focused.rect_global_position.y + focused.get_rect().size.y)
	scroll_container.set_v_scroll(scrolled_bottom)
