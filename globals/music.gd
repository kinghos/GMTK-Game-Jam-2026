extends AudioStreamPlayer

const MAIN_THEME = preload("uid://dql71kmw0qhyy")
const STATIC = preload("uid://brl7j7ipy0tgb")
var main_theme_position

func play_music(music: AudioStream):
	if stream == music:
		return
	stream = music
	bus = "Music"
	play()

func stop_music():
	stop()
	
func save_position():
	main_theme_position = get_playback_position()

func resume_at_pos():
	play(main_theme_position)
