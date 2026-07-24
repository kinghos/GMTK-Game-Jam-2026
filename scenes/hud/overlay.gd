extends CanvasLayer

@onready var animation_player: AnimationPlayer = $PowerupScreen/AnimationPlayer
@onready var options_container: HBoxContainer = $PowerupScreen/PowerupsMenu/Options
@onready var options = options_container.get_children()
@onready var descriptions_container: HBoxContainer = $PowerupScreen/PowerupsMenu/Descriptions
@onready var descriptions = descriptions_container.get_children()
@onready var value_changes_container: HBoxContainer = $PowerupScreen/PowerupsMenu/ValueChanges
@onready var value_changes = value_changes_container.get_children()

@onready var paused_time_ms = 0
@onready var weapon_select = false

signal powerups_gone

func _on_hud_show_powerups() -> void:
	paused_time_ms = 0

	var selection
	if Globals.powerups_gained != 2:
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
			
			value_changes[i].text = "%d -> %d" % [current_val, current_val + increase_val]
	else:
		weapon_select = true
		selection = Globals.WEAPONS.values()
		selection = selection.slice(1, 4)
		for i in range(3):
			options[i].set_meta("powerup_type", selection[i])
			options[i].icon = Globals.weapon_icons[selection[i]]
			options[i].text = Globals.weapon_names[selection[i]]
	$PowerupScreen.show()
	animation_player.play("powerups")

func _process(delta: float) -> void:
	paused_time_ms += delta*1000

func _on_powerup_pressed(button_num: int) -> void:
	Globals.print_powerup_values()
	
	if not weapon_select:
		var powerup_selected = options[button_num].get_meta("powerup_type")
		Globals.powerup_counts[powerup_selected] += 1
		Globals.apply_powerup(powerup_selected)
	else:
		var weapon_selected = options[button_num].get_meta("powerup_type")
		Globals.chosen_weapon = weapon_selected
	animation_player.play("fade")
	await animation_player.animation_finished
	get_tree().paused = false
	powerups_gone.emit()
	Globals.update_targets()
	Globals.start_time += floori(paused_time_ms)
	Globals.print_powerup_values()
