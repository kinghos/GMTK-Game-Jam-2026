extends CPUParticles2D

@onready var audio_stream_player_2d = $AudioStreamPlayer

func _ready():
	emitting = true
	audio_stream_player_2d.play()
	await get_tree().create_timer(lifetime).timeout
	get_tree().change_scene_to_file("res://scenes/hud/game_over.tscn")
	get_parent().queue_free()
