extends Node2D

const FODDER = preload("uid://cyaef5g41qd5j")

var wave_number = 1
var spawn_num = 10
var spawn_offset: Vector2 = Vector2(100, 100)

func _process(delta: float) -> void:
	if get_tree().get_nodes_in_group("Enemies").is_empty():
		spawn_wave() 

func spawn_wave():
	var player_pos = Globals.Player.global_position
	for i in range(wave_number * spawn_num):
		await get_tree().create_timer(0.5).timeout
		var fodder: Enemy = FODDER.instantiate()
		fodder.global_position = player_pos + spawn_offset.rotated(randf_range(0, TAU))
		add_child(fodder)
		
