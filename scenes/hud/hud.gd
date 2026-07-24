extends CanvasLayer

@onready var top_bar: ColorRect = $Control/TopBar
@onready var progress_bar: ProgressBar = $Control/TopBar/HBoxContainer/ProgressBar
@onready var timer: Label = $Control/TopBar/HBoxContainer/Timer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
var on_powerups = false

func _ready() -> void:
	Globals.start_time = Time.get_ticks_msec()

func _process(delta: float) -> void:
	var ms = Time.get_ticks_msec() - Globals.start_time
	var secs = (ms / 1000) % 60 
	var mins = floor((ms / 1000) / 60) 
	timer.text = "TIME: %02d:%02d" % [mins, secs]
	
	if Globals.current_kills_to_target == Globals.current_kill_target and not on_powerups:
		get_tree().paused = true
		on_powerups = true
		animation_player.play("powerups")
	var perc = Globals.current_kills_to_target / Globals.current_kill_target
	progress_bar.value = lerpf(progress_bar.value, perc, delta * 15)
	
