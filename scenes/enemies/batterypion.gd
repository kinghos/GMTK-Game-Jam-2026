extends Enemy

func _ready() -> void:
	super()
	enemy_type = "batterypion"

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body is Player and not dead:
		sprite_2d.hide() 
		body.disable_drops()
		body.play_anim("debuffed")
		$CollisionShape2D.set_deferred("disabled", true)
		queue_free()
