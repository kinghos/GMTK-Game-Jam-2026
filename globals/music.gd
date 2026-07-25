extends AudioStreamPlayer

const MAIN_THEME = preload("uid://dql71kmw0qhyy")
const STATIC = preload("uid://brl7j7ipy0tgb")
var main_theme_position

func play_music(music: AudioStream, start_time = null):
	if stream == music:
		return
	stream = music
	bus = "Music"
	if start_time:
		play(start_time)
	else:
		play()

	
func save_position():
	main_theme_position = get_playback_position()
