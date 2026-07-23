extends CharacterBody2D
class_name Enemy

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: AnimatedSprite2D = $Sprite2D
const ENERGY_DROP = preload("uid://hsjp7wxc6x1v")
@onready var cpu_particles_2d: CPUParticles2D = $CPUParticles2D


var enemy_type
var dead = false
@export var hp = 0
@export var damage = 0
@export var speed = 0

func attack_player():
	if Globals.player:
		velocity = global_position.direction_to(Globals.player.global_position) * speed
		sprite_2d.flip_h = velocity.x > 0
		move_and_slide()

func _process(delta: float) -> void:
	if not Globals.game_over and not dead:
		attack_player()
	if hp == 0 and not dead:
		death()

func death():
		animation_player.play("death")
		dead = true
		await animation_player.animation_finished
		var drop = ENERGY_DROP.instantiate()
		drop.global_position = global_position
		Globals.level.get_node("Drops").add_child(drop)
		await cpu_particles_2d.finished
		queue_free()
	

func take_damage(bullet_damage):
	hp = move_toward(hp, 0, bullet_damage)
