extends Node
class_name CommandHandler

# accepted commands:
# set *game_save_property* *value*
# emmit *signal name* *value*

static func executeCommands(command_lines):
	if command_lines == null:
		return
	
	for command_line in command_lines:
		execute(command_line)

static func execute(command_line: String):
	print("Command executed [", command_line, "]")
	
	var args = command_line.split(" ")
	if args.size() > 0:
		var command = args[0]
		args.remove(0)
		match command:
			"set":
				var var_name = args[0]
				var value = args[1] == "True"
				GameEventConstants.set_constant(var_name, value)
			
			"set_float":
				var var_name = args[0]
				var value = str2var(args[1])
				GameEventConstants.set_constant(var_name, float(value))
				
			"emmit":
				var signal_name = args[0]
				if EventBus.has_method(signal_name):
					if args.size() > 1:
						EventBus.call(signal_name, args[1])
					else:
						EventBus.call(signal_name)
