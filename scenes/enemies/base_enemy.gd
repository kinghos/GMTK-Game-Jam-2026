extends CharacterBody2D
class_name Enemy

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: AnimatedSprite2D = $Sprite2D

var enemy_type
@export var hp = 0
@export var damage = 0
@export var speed = 0

func attack_player():
	if Globals.player:
		velocity = global_position.direction_to(Globals.player.global_position) * speed
		sprite_2d.flip_h = velocity.x > 0
		move_and_slide()

func _process(delta: float) -> void:
	if not Globals.game_over:
		attack_player()
	if hp == 0:
		animation_player.play("death") # queue frees
		

func take_damage():
	hp = move_toward(hp, 0, damage)
