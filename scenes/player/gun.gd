extends Sprite2D

func _process(delta: float) -> void:
	var mouse_direction = get_parent().global_position.direction_to(get_global_mouse_position())
	rotation = mouse_direction.angle()
