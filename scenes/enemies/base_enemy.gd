extends CharacterBody2D
class_name Enemy

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: AnimatedSprite2D = $Sprite2D
const ENERGY_DROP = preload("res://scenes/misc/energy_drop.tscn")
@onready var death_particles: CPUParticles2D = $DeathParticles
@onready var hitbox: Area2D = $Hitbox
@onready var damage_asp: AudioStreamPlayer = $DamageASP
@onready var death_asp: AudioStreamPlayer = $DeathASP
@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D

@export_multiline var intro_name: String = "ENEMY NAME"
@export var intro_name_font_size: int = 75
@export_multiline var intro_tagline: String = "ENEMY TAGLINE"
@export var intro_tagline_position_ratio_y = 1.0

var enemy_type
var dead = false
@export var hp = 0
@export var damage = 0
@export var speed = 0

var knockback_velocity: Vector2 = Vector2.ZERO
var attack_cooldown := 0.0
var knockback_time := 0.0
var player_in_range := false

var knockback_propagated := false

func _ready():
	navigation_agent_2d.set_navigation_map(Globals.level.floor)

func move_towards_player():
	if Globals.player:
		if navigation_agent_2d.target_position != Globals.player.global_position:
			navigation_agent_2d.target_position = Globals.player.global_position
			
		var next_pos = navigation_agent_2d.get_next_path_position()
		velocity = global_position.direction_to(next_pos) * speed
		sprite_2d.flip_h = velocity.x > 0


func _physics_process(delta: float) -> void:
	if Globals.game_over or dead:
		return

	if attack_cooldown > 0:
		attack_cooldown -= delta

	if knockback_time > 0:
		knockback_time -= delta
		velocity = knockback_velocity
	else:
		move_towards_player()

	move_and_slide()

	if knockback_time > 0 and !knockback_propagated:
		for i in range(get_slide_collision_count()):
			var collision = get_slide_collision(i)
			var collider = collision.get_collider()

			if collider is Enemy and collider != self:
				collider.receive_knockback(knockback_velocity * 0.5)

		knockback_propagated = true

	if player_in_range and attack_cooldown <= 0:
		attack_player()


func _process(delta: float) -> void:
	if hp == 0 and !dead:
		die()
		
	if is_fully_on_screen() and not Globals.has_seen(enemy_type) and not Globals.level.enemy_intro.in_progress:
		Globals.mark_seen(enemy_type)
		trigger_intro()

func attack_player():
	if !Globals.player:
		return

	Globals.player.use_charge(damage)
	Globals.player.play_anim("damage")

	attack_cooldown = 0.5

	receive_knockback(
		Globals.player.global_position.direction_to(global_position) * 200,
		0.2
	)


func receive_knockback(force: Vector2, duration := 0.8):
	knockback_velocity = force
	knockback_time = duration
	knockback_propagated = false


func die():
	if Globals.player and self in Globals.player.enemies_in_blast_radius:
		Globals.player.enemies_in_blast_radius.erase(self)

	dead = true
	animation_player.play("death")
	death_asp.play()
	await animation_player.animation_finished

	Globals.enemy_kill_total += 1

	var drop = ENERGY_DROP.instantiate()
	drop.global_position = global_position
	Globals.level.get_node("Drops").add_child(drop)

	await death_particles.finished
	queue_free()


func take_damage(bullet_damage):
	animation_player.play("damage")
	damage_asp.play()
	hp = move_toward(hp, 0, bullet_damage)


func _on_hitbox_body_entered(body: Node2D) -> void:
	if body == Globals.player:
		player_in_range = true


func _on_hitbox_body_exited(body: Node2D) -> void:
	if body == Globals.player:
		player_in_range = false

func is_fully_on_screen() -> bool:
	var cam = get_viewport().get_camera_2d()
	if not cam: return false
	
	var vp_size = get_viewport_rect().size
	var cam_pos = cam.global_position
	
	var left_bound = cam_pos.x - (vp_size.x / 2.0)
	var right_bound = cam_pos.x + (vp_size.x / 2.0)
	var top_bound = cam_pos.y - (vp_size.y / 2.0)
	var bottom_bound = cam_pos.y + (vp_size.y / 2.0)
	
	return global_position.x > left_bound and global_position.x < right_bound \
	   and global_position.y > top_bound and global_position.y < bottom_bound

func trigger_intro():
	Globals.level.enemy_intro.play_intro(self, intro_name, intro_tagline)
