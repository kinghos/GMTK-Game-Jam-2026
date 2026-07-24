extends CanvasLayer

@onready var animation_player: AnimationPlayer = $PowerupScreen/AnimationPlayer
@onready var options_container: HBoxContainer = $PowerupScreen/PowerupsMenu/Options
@onready var options = options_container.get_children()
@onready var paused_time_ms = 0
@onready var weapon_select = false

func _on_hud_show_powerups() -> void:
	paused_time_ms = 0
	var selection
	if Globals.powerups_gained != 2:
		selection = Globals.POWERUPS.values()
		selection.shuffle()
		selection = selection.slice(0, 3)
		for i in range(3):
			options[i].set_meta("powerup_type", selection[i])
			options[i].icon = Globals.powerup_icons[selection[i]]
			options[i].text = Globals.powerup_names[selection[i]]
		animation_player.play("powerups")
	else:
		weapon_select = true
		selection = Globals.WEAPONS.values()
		selection = selection.slice(1, 4)
		for i in range(3):
			options[i].set_meta("powerup_type", selection[i])
			options[i].icon = Globals.weapon_icons[selection[i]]
			options[i].text = Globals.weapons_names[selection[i]]
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
		Globals.chosen_weapon = weapon_select
	animation_player.play("fade")
	await animation_player.animation_finished
	Globals.update_targets()
	get_tree().paused = false
	Globals.start_time += floori(paused_time_ms)
	Globals.print_powerup_values()
