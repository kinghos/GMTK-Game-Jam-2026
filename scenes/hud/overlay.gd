extends CanvasLayer

@onready var animation_player: AnimationPlayer = $PowerupScreen/AnimationPlayer
@onready var options_container: HBoxContainer = $PowerupScreen/PowerupsMenu/Options
@onready var options = options_container.get_children()
@onready var descriptions_container: HBoxContainer = $PowerupScreen/PowerupsMenu/Descriptions
@onready var descriptions = descriptions_container.get_children()
@onready var value_changes_container: HBoxContainer = $PowerupScreen/PowerupsMenu/ValueChanges
@onready var value_changes = value_changes_container.get_children()
@onready var select_label: Label = $PowerupScreen/SelectLabel

@onready var paused_time_ms = 0
@onready var weapon_select = false

@onready var option_4_opt: Button = $PowerupScreen/PowerupsMenu/Options/Option4
@onready var option_4_desc: Button = $PowerupScreen/PowerupsMenu/Descriptions/Option4
@onready var option_4_val: Label = $PowerupScreen/PowerupsMenu/ValueChanges/PanelContainer4/Option4

signal powerups_gone

func _on_hud_show_powerups() -> void:
	Globals.prevent_pause = true
	paused_time_ms = 0

	var selection
	if Globals.powerups_gained == 2:
		weapon_select = true
		value_changes_container.hide()
		select_label.text = "SELECT A WEAPON\n(FOR THE REST OF THE RUN)"
		selection = Globals.WEAPONS.values()
		selection = selection.slice(1, 4)
		for i in range(3):
			var p_type = selection[i]
			options[i].set_meta("powerup_type", p_type)
			options[i].icon = Globals.weapon_icons[p_type]
			options[i].text = Globals.weapon_names[p_type]
			
			var description = Globals.weapon_descriptions[p_type]
			descriptions[i].text = description
		Globals.powerups_gained += 1
	else:
		option_4_opt.hide()
		option_4_desc.hide()
		option_4_val.hide()
		select_label.text = "SELECT A POWERUP"
		value_changes_container.show()
		selection = Globals.POWERUPS.values()
		selection.shuffle()
		selection = selection.slice(0, 3)
		
		for i in range(selection.size()):
			var p_type = selection[i]
			
			options[i].set_meta("powerup_type", p_type)
			options[i].icon = Globals.powerup_icons[p_type]
			options[i].text = Globals.powerup_names[p_type]
			
			var description = Globals.powerup_descriptions[p_type]
			if Globals.powerup_counts[p_type] == 0 and Globals.powerup_first_descriptions.has(p_type):
				description = Globals.powerup_first_descriptions[p_type]
			descriptions[i].text = description
			
			var current_val = Globals.get_powerup_current_value(p_type)
			var increase_val = Globals.powerup_increases[p_type]
			
			if Globals.powerup_counts[p_type] == 0 and Globals.powerup_first_descriptions.has(p_type):
				value_changes[i].get_child(0).text = "N/A"
			else:
				value_changes[i].get_child(0).text = "%s -> %s" % [
					format_value(current_val),
					format_value(current_val + increase_val)
				]
	
	# Logic for 4th option
	var weapon = Globals.chosen_weapon
	if not weapon_select and Globals.chosen_weapon != Globals.WEAPONS.PISTOL:
		select_label.text = "SELECT A POWERUP"
		option_4_opt.show()
		option_4_desc.show()
		option_4_val.show()
		value_changes_container.show()
		
		
		selection = [] # fallback
		selection = Globals.get_associated_upgrades(weapon)
		var w_upgrade = selection.pick_random()
		option_4_opt.set_meta("powerup_type", w_upgrade)
		option_4_opt.icon = Globals.upgrade_icons_borderless[w_upgrade]
		option_4_opt.text = Globals.upgrade_names[w_upgrade]
		option_4_desc.text = Globals.upgrade_descriptions[w_upgrade]
		var current_val = Globals.get_upgrade_current_value(w_upgrade)
		var increase_val = Globals.upgrade_increases[w_upgrade]
		option_4_val.text = "%s -> %s" % [
			format_value(current_val),
			format_value(current_val + increase_val)
		]
		if Globals.upgrade_counts[w_upgrade] == 0 and Globals.upgrade_first_descriptions.has(w_upgrade):
			option_4_desc.text = Globals.upgrade_first_descriptions[w_upgrade]
			option_4_val.text = "N/A"
		option_4_val.get_parent().show()
		
	animation_player.play("powerups")

func format_value(value: float) -> String:
	if is_equal_approx(value, round(value)):
		return str(int(round(value)))
	return "%.2f" % value

func _process(delta: float) -> void:
	paused_time_ms += delta*1000

func _on_powerup_pressed(button_num: int) -> void:
	Globals.print_powerup_values()
	
	if not weapon_select:
		var powerup_selected = options[button_num].get_meta("powerup_type")
		if options[button_num] != option_4_opt:
			Globals.powerup_counts[powerup_selected] += 1
			Globals.apply_powerup(powerup_selected)
		else:
			Globals.upgrade_counts[powerup_selected] += 1
			Globals.apply_upgrade(powerup_selected)
	else:
		var weapon_selected = options[button_num].get_meta("powerup_type")
		Globals.chosen_weapon = weapon_selected
		weapon_select = false
	animation_player.stop()
	animation_player.play("fade")
	await animation_player.animation_finished
	get_tree().paused = false
	powerups_gone.emit()
	Globals.update_targets()
	Globals.start_time += floori(paused_time_ms)
	Globals.print_powerup_values()
	Globals.prevent_pause = false
	
func play_bob():
	animation_player.play("bob")
