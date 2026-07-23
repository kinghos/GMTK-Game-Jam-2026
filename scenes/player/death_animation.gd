extends GPUParticles2D

@onready var audio_stream_player_2d = $AudioStreamPlayer2D

func _ready():
	emitting = true
	audio_stream_player_2d.play()
	await get_tree().create_timer(lifetime).timeout
	get_parent().queue_free()
