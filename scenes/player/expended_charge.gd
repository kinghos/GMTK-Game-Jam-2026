extends Sprite2D
class_name Charge

const MAX_LIFETIME = 0.5 # seconds
var lifetime = MAX_LIFETIME
var velocity = Vector2.ZERO

static func create(spawn_position) -> Charge:
	var charge_scene: PackedScene = load("res://scenes/player/expended_charge.tscn")
	var new_charge: Charge = charge_scene.instantiate()
	
	new_charge.global_position = spawn_position + Vector2(0, -10)
	new_charge.velocity = randf_range(100.0, 150.0) * Vector2.RIGHT.rotated(randf_range(-PI * 0.75, -PI * 0.25))
	
	return new_charge

func _process(delta):
	lifetime -= delta
	modulate.a = lifetime / MAX_LIFETIME
	
	position += velocity * delta
	velocity *= 0.96
	
	if lifetime <= 0:
		queue_free()
