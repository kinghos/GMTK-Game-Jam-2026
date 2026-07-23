extends CanvasLayer

@onready var top_bar: ColorRect = $Control/TopBar
@onready var progress_bar: ProgressBar = $Control/TopBar/HBoxContainer/ProgressBar
@onready var timer: Label = $Control/TopBar/HBoxContainer/Timer

func _ready() -> void:
	Globals.start_time = Time.get_ticks_msec()

func _process(delta: float) -> void:
	var ms = Time.get_ticks_msec() - Globals.start_time
	var secs = (ms / 1000) % 60 
	var mins = floor((ms / 1000) / 60) 
	timer.text = "TIME: %02d:%02d" % [mins, secs]
	
