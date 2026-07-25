extends Area2D
class_name Toast

@export var speed: int = 800.0
var bullet_damage

var direction = Vector2.ZERO

func _physics_process(delta: float) -> void:
	global_position += direction * speed * delta


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.use_charge(bullet_damage)
		body.play_anim("damage")
	queue_free()
