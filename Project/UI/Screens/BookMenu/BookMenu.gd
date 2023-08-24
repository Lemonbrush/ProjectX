extends CanvasLayer

export(Array, Texture) var all_pages 
export(Texture) var lockerd_page

onready var file_manager		    = $"/root/FileManager"
onready var animation_player 	= $AnimationPlayer
onready var cancel_button		= $MainMarginContainer/GeneralMarginContainer/Cancel
onready var pages_image			= $MainMarginContainer/BookMarginContainer/BookContainer/HBoxContainer/Pages

onready var left_arrow_button 	= $MainMarginContainer/BookMarginContainer/BookContainer/HBoxContainer/LeftArrow
onready var right_arrow_button	= $MainMarginContainer/BookMarginContainer/BookContainer/HBoxContainer/RightArrow

onready var loaded_page_numbers = file_manager.get_pages().unlocked_pages

var current_page_num = 0

func _ready():
	get_tree().paused = true 
	cancel_button.connect("pressed", self, "on_cancel_pressed")
	left_arrow_button.connect("pressed", self, "left_arrow_pressed")
	right_arrow_button.connect("pressed", self, "right_arrow_pressed")
	
	show_page(current_page_num)
	
func _unhandled_input(event):
	if event.is_action_pressed("pause_menu") || event.is_action_pressed("book_menu"):
		unpause()
		get_tree().set_input_as_handled()
		
	if event.is_action_pressed("left"):
		show_page(current_page_num - 1)
	elif event.is_action_pressed("right"):
		show_page(current_page_num + 1)

####### Helpers #######

func show_page(page_num):
	if all_pages.size() > page_num && page_num >= 0:
		
		var is_unlocked = false
		for loaded_page_num in loaded_page_numbers:
			if loaded_page_num == page_num:
				is_unlocked = true
				break
		
		if is_unlocked:
			pages_image.texture = all_pages[page_num]
		else:
			pages_image.texture = lockerd_page
			
		current_page_num = page_num
	
	update_arrow_buttons()

func unpause():
	queue_free()
	get_tree().paused = false

func update_arrow_buttons():
	right_arrow_button.disabled = current_page_num + 1 >= all_pages.size()
	left_arrow_button.disabled = current_page_num - 1 <= -1
		

####### Actions #######

func left_arrow_pressed():
	show_page(current_page_num - 1)
	
func right_arrow_pressed():
	show_page(current_page_num + 1)
	
func on_cancel_pressed():
	unpause()
