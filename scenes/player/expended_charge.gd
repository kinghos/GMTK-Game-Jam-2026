extends Sprite2D
class_name Charge

const MAX_LIFETIME = 1 # seconds
var lifetime = MAX_LIFETIME

static func create(player_position) -> Charge:
	var charge_scene: PackedScene = load("res://scenes/player/expended_charge.tscn")
	var new_charge: Charge = charge_scene.instantiate()
	new_charge.global_position = player_position + Vector2.RIGHT.rotated(randf() * TAU) * sqrt(randf()) * 75
	return new_charge

func _process(delta):
	lifetime -= delta
	modulate.a = lifetime / MAX_LIFETIME
	
	if lifetime <= 0:
		queue_free()
