extends Enemy
@onready var explosion_sprite: AnimatedSprite2D = $ExplosionSprite
@onready var asp: AudioStreamPlayer = $AudioStreamPlayer

var enemies_in_range = []

func _ready() -> void:
	super()
	enemy_type = "lightbomb"
	dead = false
	asp.bus = "SFX"

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body is Player and not dead:
		explosion_sprite.show()
		explosion_sprite.play("kaboom")
		asp.play()
		sprite_2d.hide() 
		body.use_charge(damage)
		body.play_anim("damage")
		$CollisionShape2D.set_deferred("disabled", true)
		await explosion_sprite.animation_finished
		queue_free()
	if body is Enemy:
		enemies_in_range.append(body)

func _on_hitbox_body_exited(body: Node2D) -> void:
	if body in enemies_in_range:
		enemies_in_range.erase(body)

func die():
	# THIS IS FOR THE KNOCKBACK BLAST
	if Globals.player and self in Globals.player.enemies_in_blast_radius:
		Globals.player.enemies_in_blast_radius.erase(self)

	dead = true
	animation_player.play("death")
	death_asp.play()
	await animation_player.animation_finished
	$Hitbox/CollisionShape2D.disabled = false
	explosion_sprite.show()
	explosion_sprite.play("kaboom")
	asp.play()
	sprite_2d.hide() 
	print(enemies_in_range)
	for enemy: Enemy in enemies_in_range:
		enemy.take_damage(damage)
		enemy.animation_player.play("damage")
	$CollisionShape2D.set_deferred("disabled", true)
	await explosion_sprite.animation_finished
	
	Globals.enemy_kill_total += 1

	var drop = ENERGY_DROP.instantiate()
	drop.global_position = global_position
	Globals.level.get_node("Drops").add_child(drop)

	await death_particles.finished
	queue_free()
