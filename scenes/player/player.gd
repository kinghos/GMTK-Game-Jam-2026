extends CharacterBody2D
class_name Player

const DEATH_ANIMATION = preload("res://scenes/player/death_animation.tscn")

const IDLE_DRAIN = 1.0
const MOVING_DRAIN = 6.0
const CHARGE_PER_EXPEND = 2.0

const WALK_SPEED = 150.0
const SPRINT_SPEED = 400.0

const MAX_CHARGE = 100

@onready var gun: Sprite2D = $Gun
@onready var sprite_2d: AnimatedSprite2D = $Sprite2D
@onready var blast_particles: CPUParticles2D = $BlastParticles
@onready var blast_timer: Timer = $BlastTimer


var charge = MAX_CHARGE
var charge_spent_since_expend = 0.0
var dead = false

var shoot_cooldown = 0.0

const SPRINT_TRAIL_INTERVAL = 0.05
const SPRINT_TRAIL_LIFETIME = 0.2
var sprinting_trail_timer = 0.0

var enemies_in_blast_radius = []

func _ready():
	Globals.player = self

func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("Left", "Right", "Up", "Down")
	var sprinting = Input.is_action_pressed("Sprint")
	
	if direction.x < 0:
		sprite_2d.flip_h = true
	elif direction.x > 0:
		sprite_2d.flip_h = false
	
	if Input.is_action_just_pressed("Blast"):
		blast()
	
	var current_speed = WALK_SPEED if direction else 0
	if sprinting:
		current_speed = SPRINT_SPEED
		if direction != Vector2.ZERO:
			sprinting_trail_timer -= delta
			if sprinting_trail_timer <= 0:
				sprinting_trail_timer = SPRINT_TRAIL_INTERVAL
				spawn_sprint_trail_image()
		else:
			sprinting_trail_timer = 0.0
	else:
		sprinting_trail_timer = 0.0
	
	velocity = current_speed * direction
	move_and_slide()
	
	shoot_cooldown -= delta
	if Input.is_action_just_pressed("Shoot"):
		gun.shoot()
		shoot_cooldown = gun.fire_rate
	elif Input.is_action_pressed("Shoot") and shoot_cooldown <= 0:
		gun.shoot()
		shoot_cooldown = gun.fire_rate
	
	var speed_percent = current_speed / SPRINT_SPEED
	var drain = (IDLE_DRAIN + MOVING_DRAIN * speed_percent) * delta
	use_charge(drain)
	
	if charge <= 0 and not dead:
		die()
		dead = true

func spawn_sprint_trail_image():
	var ghost = Sprite2D.new()
	var cur_texture = sprite_2d.sprite_frames.get_frame_texture("run", sprite_2d.frame)
	ghost.texture = cur_texture
	ghost.global_position = global_position
	ghost.rotation = sprite_2d.rotation
	ghost.scale = sprite_2d.scale
	ghost.flip_h = sprite_2d.flip_h
	ghost.flip_v = sprite_2d.flip_v
	
	ghost.modulate = Color(1, 1, 1, 0.6)
	get_tree().current_scene.add_child(ghost)
	
	var tween = ghost.create_tween()
	tween.tween_property(ghost, "modulate:a", 0.0, SPRINT_TRAIL_LIFETIME)
	tween.finished.connect(ghost.queue_free)

func use_charge(amount):
	charge -= amount
	charge_spent_since_expend += amount
	while charge_spent_since_expend >= CHARGE_PER_EXPEND:
		expend_charge()
		charge_spent_since_expend -= CHARGE_PER_EXPEND
		
func expend_charge():
	var new_charge = Charge.create(Globals.slider.get_grabber_position())
	Globals.slider.add_child(new_charge)

func die():
	var death_anim = DEATH_ANIMATION.instantiate()
	add_child(death_anim)
	Globals.game_over = true

func energy_gain(energy_gained):
	charge += energy_gained
	
func blast():
	if blast_timer.is_stopped():
		print("kablow!")
		blast_timer.start()
		blast_particles.emitting = true
		for enemy in enemies_in_blast_radius:
			enemy.attack_cooldown = 0.75
			enemy.knockback_time = 0.5
			enemy.knockback_velocity = global_position.direction_to(enemy.global_position) * 200
		


func _on_blast_radius_body_entered(body: Node2D) -> void:
	if body is Enemy:
		enemies_in_blast_radius.append(body)


func _on_blast_radius_body_exited(body: Node2D) -> void:
	if body is Enemy:
		enemies_in_blast_radius.erase(body)
