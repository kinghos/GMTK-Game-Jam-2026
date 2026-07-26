extends Enemy

@onready var toast_cooldown: Timer = $ToastCooldown
const TOAST = preload("uid://dafocwk1p0q1u")

func _ready() -> void:
	enemy_type = "toaster"
	
func move_towards_player():
	if Globals.player:
		if navigation_agent_2d.target_position != Globals.player.global_position:
			navigation_agent_2d.target_position = Globals.player.global_position
		var next_pos = navigation_agent_2d.get_next_path_position()
		velocity = global_position.direction_to(next_pos) * speed
		sprite_2d.flip_h = velocity.x > 0
		
		var direction = Globals.player.global_position - global_position
		if direction.length() < 160:
			velocity = Vector2.ZERO
			if toast_cooldown.is_stopped():
				toast_cooldown.start()
				var toast: Toast = TOAST.instantiate()
				toast.global_position = global_position
				toast.bullet_damage = damage
				toast.direction = direction.normalized()
				get_tree().current_scene.get_node("Bullets").add_child(toast, true)
				animation_player.play("attack")
		else:
			animation_player.play("run")
