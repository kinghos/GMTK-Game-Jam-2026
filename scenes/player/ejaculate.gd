extends Node2D
class_name Ejaculate

const MAX_LIFETIME = 2.5
var lifetime = MAX_LIFETIME

static func create_ejaculate(position) -> Ejaculate:
	var ejaculate_scene: PackedScene = load("res://scenes/player/Ejaculate.tscn")
	var new_ejaculate: Ejaculate = ejaculate_scene.instantiate()
	new_ejaculate.global_position = position
	return new_ejaculate

func _process(delta):
	lifetime -= delta
	modulate.a = lifetime / MAX_LIFETIME
	
	if lifetime <= 0:
		queue_free()
