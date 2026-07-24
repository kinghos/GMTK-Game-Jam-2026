extends Sprite2D

const BULLET = preload("res://scenes/player/bullet.tscn")

@export var fire_rate = 0.6 # Seconds between shots
@export var charge_cost = 2.5

var mouse_direction

func _process(delta: float) -> void:
	mouse_direction = Globals.player.global_position.direction_to(get_global_mouse_position())
	rotation = mouse_direction.angle()
	flip_v = rotation > PI/2 and rotation < (3 * PI / 2)

func shoot():
	var bullet = BULLET.instantiate()
	bullet.global_position = global_position + offset.rotated(rotation)
	bullet.rotation = rotation
	bullet.direction = mouse_direction
	
	get_tree().current_scene.get_node("Bullets").add_child(bullet, true)
	Globals.player.use_charge(charge_cost)
