extends CanvasLayer

@onready var top_bar: ColorRect = $Control/TopBar
@onready var progress_bar: ProgressBar = $Control/TopBar/HBoxContainer/ProgressBar
@onready var timer: Label = $Control/TopBar/HBoxContainer/Timer
@onready var powerup_icons: HBoxContainer = $Control/TopBar/PowerupIcons
@onready var blast_recharge: TextureProgressBar = $Control/BlastRecharge
@onready var instructions: ColorRect = $Control/Instructions

var on_powerups = false
signal show_powerups

func _ready() -> void:
	Globals.start_time = Time.get_ticks_msec()
	blast_recharge.hide()
	instructions.visible = not get_tree().current_scene.name == "GameOver"

func _process(delta: float) -> void:
	var ms = Time.get_ticks_msec() - Globals.start_time
	var secs = ms / 1000 % 60 
	var mins = floor((ms / 1000) / 60) 
	timer.text = "TIME: %02d:%02d" % [mins, secs]
	Globals.time_elapsed = "%02d:%02d" % [mins, secs]
	update_powerup_hud()
	
	if Globals.enemy_kill_total >= Globals.current_kill_target and not on_powerups and Globals.player:
		on_powerups = true
		show_powerups.emit()
		get_tree().paused = true
	var perc = (Globals.enemy_kill_total - Globals.prev_target) / (Globals.current_kill_target - Globals.prev_target)
	if perc == 0:
		progress_bar.value = 0
	else:
		progress_bar.value = lerpf(progress_bar.value, perc, delta * 15)
	
	if blast_recharge.visible:
		var timer = Globals.player.blast_timer
		blast_recharge.value = timer.time_left / timer.wait_time * 100
		if blast_recharge.value == 0:
			blast_recharge.material.set_shader_parameter("width", 1.0)
		else:
			blast_recharge.material.set_shader_parameter("width", 0.0)
			

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
			icon.texture = Globals.upgrade_icons_bordered[upgrade]
			if Globals.upgrade_counts[upgrade] == 0:
				smat.set_shader_parameter("enabled", true)
			else:
				icon.get_child(0).text = str(Globals.upgrade_counts[upgrade])
				smat.set_shader_parameter("enabled", false)
			c += 1
	
	if Globals.powerup_counts[Globals.POWERUPS.BLAST] > 0:
		blast_recharge.show()


func _on_overlay_powerups_gone() -> void:
	on_powerups = false
