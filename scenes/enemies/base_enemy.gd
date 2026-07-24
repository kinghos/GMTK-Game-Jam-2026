extends CharacterBody2D
class_name Enemy

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: AnimatedSprite2D = $Sprite2D
const ENERGY_DROP = preload("res://scenes/misc/energy_drop.tscn")
@onready var cpu_particles_2d: CPUParticles2D = $CPUParticles2D
@onready var hitbox: Area2D = $Hitbox

var enemy_type
var dead = false
@export var hp = 0
@export var damage = 0
@export var speed = 0

var knockback_velocity = 0.0
var attack_cooldown = 0.0
var knockback_time = 0.0

func move_towards_player():
	if Globals.player:
		velocity = global_position.direction_to(Globals.player.global_position) * speed
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

func _process(delta: float) -> void:
	if hp == 0 and not dead:
		die()

func die():
	if Globals.player and self in Globals.player.enemies_in_blast_radius:
		Globals.player.enemies_in_blast_radius.erase(self)
	dead = true
	animation_player.play("death")
	await animation_player.animation_finished
	Globals.enemy_kill_total += 1
	Globals.current_kills_to_target += 1
	var drop = ENERGY_DROP.instantiate()
	drop.global_position = global_position
	Globals.level.get_node("Drops").add_child(drop)
	await cpu_particles_2d.finished
	queue_free()

func take_damage(bullet_damage):
	var bullet_damage_increase = Globals.calc_powerup_effect(Globals.POWERUPS.BULLETDMG)
	hp = move_toward(hp, 0, bullet_damage)


func _on_hitbox_body_entered(body: Node2D) -> void:
	if body != Globals.player:
		return
	if attack_cooldown > 0:
		return
	
	body.use_charge(damage)
	attack_cooldown = 0.5
	knockback_time = 0.2
	knockback_velocity = body.global_position.direction_to(global_position) * 200
