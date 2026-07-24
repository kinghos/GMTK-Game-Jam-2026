extends Sprite2D

const BULLET = preload("res://scenes/player/bullet.tscn")

@export var fire_rate = 0.6 # Seconds between shots
@export var charge_cost = 2.5

var mouse_direction: Vector2

func _process(delta: float) -> void:
	mouse_direction = Globals.player.global_position.direction_to(get_global_mouse_position())
	rotation = mouse_direction.angle()
	flip_v = rotation > PI/2 or rotation < -(PI / 2)
	
	var weapon = Globals.chosen_weapon
	texture = Globals.weapon_sprites[weapon]
	Globals.bullet_damage = Globals.weapon_damages[weapon]
	Globals.bullet_speed = Globals.weapon_bullet_speeds[weapon]

func shoot():
	var weapon = Globals.chosen_weapon
	var bullet: Bullet = BULLET.instantiate()
	var scale = Globals.weapon_bullet_sizes[weapon]
	bullet.scale = Vector2(scale, scale)
	fire_rate = Globals.weapon_attack_speeds[weapon]
	if weapon == Globals.WEAPONS.PISTOL:
		bullet.global_position = global_position + offset.rotated(rotation)
		bullet.rotation = rotation
		bullet.direction = mouse_direction
		
		get_tree().current_scene.get_node("Bullets").add_child(bullet)
		Globals.player.use_charge(charge_cost)
	elif Globals.chosen_weapon == Globals.WEAPONS.SHOTGUN:
		for i in range(Globals.shotgun_bullets):
			var rotation_offset = randf_range(-PI/12, PI/12)
			var position_offset = Vector2(randf_range(-10, 10), randf_range(-10, 10))
			
			bullet = BULLET.instantiate()
			scale = Globals.weapon_bullet_sizes[weapon]
			bullet.scale = Vector2(scale, scale)
			bullet.global_position = global_position + offset.rotated(rotation) + position_offset
			bullet.rotation = rotation
			bullet.direction = mouse_direction.rotated(rotation_offset)
			
			get_tree().current_scene.get_node("Bullets").add_child(bullet)
		Globals.player.use_charge(charge_cost * Globals.shotgun_bullets / 2)
	if weapon == Globals.WEAPONS.SMG:
		bullet.global_position = global_position + offset.rotated(rotation)
		bullet.rotation = rotation
		bullet.direction = mouse_direction
		
		get_tree().current_scene.get_node("Bullets").add_child(bullet)
		Globals.player.use_charge(charge_cost / 2)
	if weapon == Globals.WEAPONS.RIFLE:
		bullet.global_position = global_position + offset.rotated(rotation)
		bullet.rotation = rotation
		bullet.direction = mouse_direction
		
		get_tree().current_scene.get_node("Bullets").add_child(bullet)
		Globals.player.use_charge(charge_cost * 2)
