extends CanvasLayer

@onready var animation_player: AnimationPlayer = $PowerupScreen/AnimationPlayer

func _on_hud_show_powerups() -> void:
	animation_player.play("powerups")


func _on_powerup_pressed(button_num: int) -> void:
	animation_player.play("fade")
	await animation_player.animation_finished
	get_tree().paused = false
	
