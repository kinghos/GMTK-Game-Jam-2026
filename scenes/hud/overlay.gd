extends CanvasLayer

@onready var animation_player: AnimationPlayer = $PowerupScreen/AnimationPlayer
@onready var options: HBoxContainer = $PowerupScreen/PowerupsMenu/Options

func _on_hud_show_powerups() -> void:
	var selection = Globals.POWERUPS.keys()
	selection.shuffle()
	selection = selection.slice(0, 3)
	for i in range(len(selection)):
		selection[i] = Globals.POWERUPS[selection[i]]
	var options = options.get_children()
	for i in range(3):
		options[i].set_meta("powerup_type", selection[i])
		options[i].icon = Globals.powerup_icons[selection[i]]
		options[i].text = Globals.powerup_names[selection[i]]
	animation_player.play("powerups")


func _on_powerup_pressed(button_num: int) -> void:
	animation_player.play("fade")
	await animation_player.animation_finished
	get_tree().paused = false
	
