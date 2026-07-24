extends Area2D
class_name Bullet


var direction = Vector2.ZERO

func _physics_process(delta: float) -> void:
	global_position += direction * Globals.bullet_speed * delta

 
func _on_body_entered(body: Node2D) -> void:
	if body is Enemy:
		body.take_damage(Globals.bullet_damage)
		queue_free()
