extends CanvasLayer

@onready var animation_player: AnimationPlayer = $PowerupScreen/AnimationPlayer

func _on_hud_show_powerups() -> void:
	animation_player.play("powerups")
