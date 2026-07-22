extends Area2D
class_name Bullet

@export var speed: int = 800.0

var direction = Vector2.ZERO

func _physics_process(delta: float) -> void:
	global_position += direction * speed * delta
