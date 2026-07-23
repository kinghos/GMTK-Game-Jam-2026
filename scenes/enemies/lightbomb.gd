extends Enemy
@onready var explosion_sprite: AnimatedSprite2D = $ExplosionSprite
@onready var asp: AudioStreamPlayer = $AudioStreamPlayer

func _ready() -> void:
	enemy_type = "lightbomb"

<<<<<<< HEAD

func _on_explosion_area_body_entered(body: Node2D) -> void:
=======
func _on_hitbox_body_entered(body: Node2D) -> void:
>>>>>>> f769068f198827f6ae1aed5185d257da6a86a2ad
	if body is Player and not dead:
		explosion_sprite.show()
		explosion_sprite.play("kaboom")
		asp.play()
		sprite_2d.hide() 
		body.use_charge(damage)
		$CollisionShape2D.set_deferred("disabled", true)
		await explosion_sprite.animation_finished
		queue_free()
