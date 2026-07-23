extends CharacterBody2D
class_name Enemy

var enemy_type
@export var hp = 0
@export var damage = 0
@export var speed = 0

func attack_player():
	velocity = global_position.direction_to(Globals.player.global_position) * speed
	move_and_slide()

func _process(delta: float) -> void:
	if not Globals.game_over:
		attack_player()
