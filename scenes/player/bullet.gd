extends Area2D
class_name Bullet

var direction = Vector2.ZERO
@onready var pierced = 0
var last_enemy_entered: Enemy

var homing_offset: Vector2
var targeted_enemy: Enemy
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var homing_shape: CollisionShape2D = $HomingRadius/CollisionShape2D

func _ready() -> void:
	var shape = CircleShape2D.new()
	shape.radius = 36.0
	shape.radius *=  1 + (Globals.smg_home_strength / 6)
	homing_shape.shape = shape

func _physics_process(delta: float) -> void:
	var speed_increase = Globals.calc_powerup_effect(Globals.POWERUPS.BULLETSPEED)
	var speed = Globals.bullet_speed + speed_increase
	
	if Globals.chosen_weapon == Globals.WEAPONS.SMG and targeted_enemy and Globals.smg_home_strength != 0:
		direction = global_position.direction_to(targeted_enemy.global_position)

	global_position += direction * speed * delta 

 
func _on_body_entered(body: Node2D) -> void:
	if body is Enemy:
		body.take_damage(Globals.bullet_damage + Globals.calc_powerup_effect(Globals.POWERUPS.BULLETDMG))
		if Globals.chosen_weapon == Globals.WEAPONS.SMG:
			body.knockback_time = Globals.smg_kb
			body.knockback_velocity = global_position.direction_to(body.global_position) * 200
		if Globals.chosen_weapon != Globals.WEAPONS.RIFLE:
			queue_free()
		print(body != last_enemy_entered)
		if Globals.chosen_weapon == Globals.WEAPONS.RIFLE and not is_equal_approx(pierced, Globals.rifle_pierce) and body != last_enemy_entered:
			pierced += 1
			last_enemy_entered = body
		else:
			queue_free()
	else:
		queue_free()


func _on_timer_timeout() -> void:
	queue_free()


func _on_homing_radius_body_entered(body: Node2D) -> void:
	if body is Enemy and Globals.chosen_weapon == Globals.WEAPONS.SMG and targeted_enemy == null:
		targeted_enemy = body

func _on_homing_radius_body_exited(body: Node2D) -> void:
	if body == targeted_enemy and Globals.chosen_weapon == Globals.WEAPONS.SMG:
		targeted_enemy = null
		collision_shape_2d.set_deferred("disabled", true)
		collision_shape_2d.set_deferred("disabled", false)
