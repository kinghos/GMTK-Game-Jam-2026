extends HSlider

func _process(delta: float) -> void:
	if Globals.player:
		max_value = Globals.player.MAX_CHARGE * 1000
		value = Globals.player.charge * 1000
