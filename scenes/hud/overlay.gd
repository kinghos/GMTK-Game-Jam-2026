extends CanvasLayer

@onready var animation_player: AnimationPlayer = $PowerupScreen/AnimationPlayer
@onready var options_container: HBoxContainer = $PowerupScreen/PowerupsMenu/Options
@onready var options = options_container.get_children()

func _on_hud_show_powerups() -> void:
	var selection = Globals.POWERUPS.keys()
	selection.shuffle()
	selection = selection.slice(0, 3)
	for i in range(len(selection)):
		selection[i] = Globals.POWERUPS[selection[i]]
	for i in range(3):
		options[i].set_meta("powerup_type", selection[i])
		options[i].icon = Globals.powerup_icons[selection[i]]
		options[i].text = Globals.powerup_names[selection[i]]
	animation_player.play("powerups")


func _on_powerup_pressed(button_num: int) -> void:
	Globals.print_powerup_values()
	var powerup_selected = options[button_num].get_meta("powerup_type")
	Globals.powerup_counts[powerup_selected] += 1
	animation_player.play("fade")
	await animation_player.animation_finished
	Globals.update_targets()
	Globals.apply_powerup(powerup_selected)
	get_tree().paused = false
	Globals.print_powerup_values()
	
