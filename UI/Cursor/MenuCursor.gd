extends TextureRect

export var menu_parent_path: NodePath
export var cursor_offset: Vector2
export var is_focused = true
export var is_active = true

onready var menu_parent = get_node(menu_parent_path)

var cursor_active_setting

var cursor_index = 0

func _process(delta):
	EventBus.connect("did_update_cursor_setting", self, "disable_cursor")
	update_cursor_setting()
	
	if !is_active:
		return

	var input = Vector2.ZERO
	
	if Input.is_action_just_pressed("up"):
		input.y -= 1
	if Input.is_action_just_pressed("down"):
		input.y += 1
	if Input.is_action_just_pressed("left"):
		input.x -= 1
	if Input.is_action_just_pressed("right"):
		input.x += 1
		
	if menu_parent is VBoxContainer:
		set_cursor_from_index(cursor_index + input.y)
	elif menu_parent is HBoxContainer:
		set_cursor_from_index(cursor_index + input.x)
	elif menu_parent is GridContainer:
		set_cursor_from_index(cursor_index + input.x + input.y * menu_parent.columns)
	
	if Input.is_action_just_pressed("ui_select"):
		var current_menu_item = get_menu_item_at_index(cursor_index)
		if current_menu_item != null:
			if current_menu_item is Button && !current_menu_item.disabled:
				current_menu_item.emit_signal("pressed")

func get_menu_item_at_index(index: int) -> Control:
	if menu_parent == null:
		return null
		
	if index >= menu_parent.get_child_count() or index < 0:
		return null
		
	return menu_parent.get_child(index) as Control
	
func set_cursor_from_index(index: int) -> void:
	var menu_item = get_menu_item_at_index(index)
	
	if menu_item == null:
		return
		
	var position = menu_item.rect_global_position
	var size = menu_item.rect_size
	
	rect_global_position = Vector2(position.x, position.y + size.y / 2.0) - (rect_size / 2.0) - cursor_offset
	cursor_index = index

func update_cursor_setting():
	cursor_active_setting = SettingsManager.settings.is_cursor_active
	
	if cursor_active_setting:
		activate_cursor()
	else:
		disable_cursor()

func disable_cursor():
	if !is_focused:
		return
	
	is_active = false
	visible = false

func activate_cursor():
	if !is_focused:
		return
	
	is_active = true
	visible = true
