extends CharacterBody2D
class_name Player

var distance_since_last_ejaculated = 0
var health_that_goes_down_with_the_mystery_undecided_ejaculate = 100
const IDLE_EJACULATING = 1.0
const MOVING_EJACULATING = 6.0
const MAX_SPEED = 400.0

const HE_FUCKING_EXPLODED_NOOOOO = preload("res://scenes/player/he_fucking_explodes_NOOOOOOOO.tscn")
const BULLET = preload("res://scenes/bullet.tscn")

var shoot_timer = 0.0
@export var fire_rate = 0.75 # seconds between shots?

@onready var gun: Sprite2D = $Gun

var ejaculate_timer = 0

func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("Left", "Right", "Up", "Down")
	velocity = MAX_SPEED * direction
	move_and_slide()
	
	shoot_timer -= delta
	if Input.is_action_just_pressed("Shoot"):
		shoot()
		shoot_timer = fire_rate
	elif Input.is_action_pressed("Shoot") and shoot_timer <= 0:
		shoot()
		shoot_timer = fire_rate
	
	var speed_percent = clamp(velocity.length() / MAX_SPEED, 0.0, 1.0)
	health_that_goes_down_with_the_mystery_undecided_ejaculate -= (IDLE_EJACULATING + MOVING_EJACULATING * speed_percent) * delta
	
	if health_that_goes_down_with_the_mystery_undecided_ejaculate <= 0:
		die()
		return
	
	ejaculate_timer += delta
	
	var interval = lerp(1.2, 0.08, speed_percent)
	
	if ejaculate_timer >= interval:
		spawn_ejaculate()
		ejaculate_timer = 0

func spawn_ejaculate():
	var new_ejaculate = Ejaculate.create_ejaculate(global_position)
	get_tree().current_scene.add_child(new_ejaculate)

func shoot():
	var bullet = BULLET.instantiate()
	bullet.global_position = gun.global_position + gun.offset.rotated(gun.rotation)
	bullet.rotation = gun.rotation
	bullet.direction = (get_global_mouse_position() - global_position).normalized()
	get_parent().add_child(bullet)

func die():
	var NOOOOOOOOOOO = HE_FUCKING_EXPLODED_NOOOOO.instantiate()
	NOOOOOOOOOOO.global_position = global_position
	get_tree().current_scene.add_child(NOOOOOOOOOOO)
