extends AudioStreamPlayer

const MAIN_THEME = preload("uid://dql71kmw0qhyy")

func play_music(music: AudioStream):
	if stream == music:
		return
	stream = music
	bus = "Music"
	play()

func stop_music():
	stop()
