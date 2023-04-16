extends Control

export var menu_parent_path: NodePath
export var cursor_offset: Vector2
export var is_focused = true

onready var animation_player = $AnimationPlayer
onready var menu_parent = get_node(menu_parent_path)

var cursor_active_setting
var cursor_index = 0

func _ready():
	var _connection = EventBus.connect("did_update_cursor_setting", self, "update_cursor_setting")
	update_cursor_setting()

func _process(delta):
	if is_focused && cursor_active_setting:
		visible = true
	else:
		visible = false
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
		animation_player.play("Click")

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

func press_button():
	var current_menu_item = get_menu_item_at_index(cursor_index)
	if current_menu_item != null:
		if current_menu_item is Button && !current_menu_item.disabled:
			current_menu_item.emit_signal("pressed")

func update_cursor_setting():
	cursor_active_setting = SettingsManager.settings.is_cursor_active

func focuse(should_focuse):
	is_focused = should_focuse
	visible = false
