extends Area2D
class_name Bullet

@export var speed: int = 800.0
var bullet_damage: int = 50

var direction = Vector2.ZERO

func _physics_process(delta: float) -> void:
	global_position += direction * speed * delta

 
func _on_body_entered(body: Node2D) -> void:
	if body is Enemy:
		body.take_damage(bullet_damage)
		queue_free()
