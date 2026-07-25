extends CPUParticles2D

@onready var audio_stream_player_2d = $AudioStreamPlayer

func _ready():
	emitting = true
	$Warning2.emitting = true
	$Caution.emitting = true
	audio_stream_player_2d.play()
	await get_tree().create_timer(lifetime).timeout
	Globals._ready()
	Music.save_position()
	Music.play_music(Music.STATIC)
	get_tree().change_scene_to_file("res://scenes/hud/game_over.tscn")
