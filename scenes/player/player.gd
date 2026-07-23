extends CharacterBody2D
class_name Player

const DEATH_ANIMATION = preload("res://scenes/player/death_animation.tscn")

const IDLE_DRAIN = 1.0
const MOVING_DRAIN = 6.0

const WALK_SPEED = 400.0
const SPRINT_SPEED = 700.0

const MAX_CHARGE = 100

@onready var gun: Sprite2D = $Gun

var charge = MAX_CHARGE
var dead = false

var shoot_cooldown = 0.0

var expended_charge_timer = 0

func _ready():
	Globals.player = self

func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("Left", "Right", "Up", "Down")
	var sprinting = Input.is_action_pressed("Sprint")
	
	var current_speed = WALK_SPEED
	if sprinting:
		current_speed = SPRINT_SPEED
	
	velocity = current_speed * direction
	move_and_slide()
	
	shoot_cooldown -= delta
	if Input.is_action_just_pressed("Shoot"):
		gun.shoot()
		shoot_cooldown = gun.fire_rate
	elif Input.is_action_pressed("Shoot") and shoot_cooldown <= 0:
		gun.shoot()
		shoot_cooldown = gun.fire_rate
	
	var speed_percent = clamp(velocity.length() / SPRINT_SPEED, 0.0, 1.0)
	charge -= (IDLE_DRAIN + MOVING_DRAIN * speed_percent) * delta
	
	if charge <= 0 and not dead:
		die()
		dead = true
	
	expended_charge_timer += delta
	
	var interval = lerp(1.5, 0.1, speed_percent)
	
	if expended_charge_timer >= interval:
		expend_charge()
		expended_charge_timer = 0

func expend_charge():
	var new_charge = Charge.create(global_position)
	get_tree().current_scene.add_child(new_charge)

func die():
	var death_anim = DEATH_ANIMATION.instantiate()
	add_child(death_anim)
	Globals.game_over = true

func energy_gain(energy_gained):
	charge += energy_gained
