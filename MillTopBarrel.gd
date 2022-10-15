extends Barrel

func destruct(_area = null):
	.destruct()
	EventBus.mill_gear_barrel_destructed()
	GameEventConstants.set_constant("is_mill_gear_clanged", false)
