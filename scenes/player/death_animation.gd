extends CPUParticles2D


func _ready():
	emitting = true
	$Warning2.emitting = true
	$Caution.emitting = true
	await get_tree().create_timer(lifetime).timeout
	Music.save_position()
	Music.play_music(Music.STATIC)
	get_tree().change_scene_to_file("res://scenes/hud/game_over.tscn")
