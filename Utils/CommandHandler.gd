extends Node
class_name CommandHandler

# accepted commands:
# set *game_save_property* *value*
# emmit *signal name* *value*

static func executeCommands(command_lines):
	for command_line in command_lines:
		execute(command_line)

static func execute(command_line: String):
	var args = command_line.split(" ")
	
	if args.size() > 0:
		var command = args[0]
		args.remove(0)
		
		match command:
			"set":
				var var_name = args[0]
				var value = str2var(args[1])
				
				GameEventConstants.set_constant(var_name, value)
			"emmit":
				pass
