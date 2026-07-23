extends Enemy
@onready var explosion_sprite: AnimatedSprite2D = $ExplosionSprite
@onready var asp: AudioStreamPlayer = $AudioStreamPlayer

func _ready() -> void:
	enemy_type = "lightbomb"

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body is Player and not dead:
		explosion_sprite.show()
		explosion_sprite.play("kaboom")
		asp.play()
		body.use_charge(damage)
		$CollisionShape2D.set_deferred("disabled", true)
		await explosion_sprite.animation_finished
		queue_free()
