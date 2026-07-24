extends CanvasLayer

@onready var top_bar: ColorRect = $Control/TopBar
@onready var progress_bar: ProgressBar = $Control/TopBar/HBoxContainer/ProgressBar
@onready var timer: Label = $Control/TopBar/HBoxContainer/Timer
@onready var powerup_icons: HBoxContainer = $Control/TopBar/PowerupIcons
var on_powerups = false
signal show_powerups

func _ready() -> void:
	Globals.start_time = Time.get_ticks_msec()

func _process(delta: float) -> void:
	var ms = Time.get_ticks_msec() - Globals.start_time
	var secs = ms / 1000 % 60 
	var mins = floor((ms / 1000) / 60) 
	timer.text = "TIME: %02d:%02d" % [mins, secs]
	update_powerup_hud()
	
	if Globals.enemy_kill_total >= Globals.current_kill_target and not on_powerups and Globals.player:
		on_powerups = true
		show_powerups.emit()
		get_tree().paused = true
	var perc = Globals.current_kills_to_target / Globals.current_kill_target
	progress_bar.value = lerpf(progress_bar.value, perc, delta * 15)

func all_values_zero(dict: Dictionary) -> bool:
	for value in dict.values():
		if value != 0:
			return false
	return true

func update_powerup_hud():
	if all_values_zero(Globals.powerup_counts) and all_values_zero(Globals.upgrade_counts):
		powerup_icons.hide()
	else:
		powerup_icons.show()
	
	for powerup_name in Globals.POWERUPS.keys():
		var powerup = Globals.POWERUPS[powerup_name]
		var icon = powerup_icons.get_node(powerup_name)
		var smat = icon.material as ShaderMaterial
		if Globals.powerup_counts[powerup] == 0:
			smat.set_shader_parameter("enabled", true)
		else:
			icon.get_child(0).text = str(Globals.powerup_counts[powerup])
			smat.set_shader_parameter("enabled", false)
	
	if Globals.chosen_weapon != Globals.WEAPONS.PISTOL:
		var c = 1
		for upgrade in Globals.get_associated_upgrades(Globals.chosen_weapon):
			var icon = powerup_icons.get_node("WeaponUpgrade" + str(c))
			var smat = icon.material as ShaderMaterial
			icon.texture = Globals.upgrade_icons[upgrade]
			if Globals.upgrade_counts[upgrade] == 0:
				smat.set_shader_parameter("enabled", true)
			else:
				icon.get_child(0).text = str(Globals.upgrade_counts[upgrade])
				smat.set_shader_parameter("enabled", false)
			c += 1


func _on_overlay_powerups_gone() -> void:
	on_powerups = false
