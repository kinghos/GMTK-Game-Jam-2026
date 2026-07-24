extends Area2D
class_name Bullet


var direction = Vector2.ZERO

func _physics_process(delta: float) -> void:
	var speed_increase = Globals.calc_powerup_effect(Globals.POWERUPS.BULLETSPEED)
	global_position += direction * (Globals.bullet_speed + speed_increase) * delta

 
func _on_body_entered(body: Node2D) -> void:
	if body is Enemy:
		body.take_damage(Globals.bullet_damage)
		queue_free()
