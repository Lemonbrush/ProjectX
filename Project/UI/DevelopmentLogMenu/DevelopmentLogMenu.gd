extends CanvasLayer
signal back_pressed

onready var mainMarginContainer = $MainMarginContainer
onready var textLabel = $MainMarginContainer/MarginContainer/RichTextLabel

var changelog_link = "res://ProjectResources/CHANGELOG.md"

func _ready():
	textLabel.append_bbcode(load_file(changelog_link))
	textLabel.grab_focus()

func _unhandled_input(_event):
	if Input.is_action_just_pressed("pause_menu") and mainMarginContainer.visible:
		on_quit_pressed()
		
func on_quit_pressed():
	queue_free()
	emit_signal("back_pressed")

func load_file(file):
	var f = File.new()
	f.open(file, File.READ)
	var final_text = ""
	while not f.eof_reached():
		var line = f.get_line()
		line = prettify_line(line)
		final_text += line
	f.close()
	return final_text

func prettify_line(text):
	var final_text = text
	var first_char_part = text.split(" ")[0]
	if first_char_part == "#" or first_char_part == "##":
		final_text = final_text.to_upper()
		final_text = "[color=white]" + final_text + "[/color]"
	elif first_char_part == "###":
		final_text = "[color=#8ea8fa]" + final_text + "[/color]"
	else:
		final_text = "[color=#cccccc]" + final_text + "[/color]"
	
	final_text = final_text.replace("# ", "")
	final_text = final_text.replace("##", "")
	final_text = final_text.replace("#[", "[")
	final_text += "\n"
	return final_text
