extends Node2D
class_name Level
const FODDER = preload("uid://cyaef5g41qd5j")

var wave_number = 1
var spawn_num = 10
var spawn_offset_radius = 500
var wave_complete = false
var spawn_offset: Vector2 = Vector2(spawn_offset_radius, spawn_offset_radius)

func _ready() -> void:
	Globals.level = self

func _process(delta: float) -> void:
	if get_tree().get_nodes_in_group("Enemies").is_empty() and not wave_complete:
		wave_complete = true
		spawn_wave() 

func spawn_wave():
	var player_pos = Globals.player.global_position
	for i in range(wave_number * spawn_num):
		await get_tree().create_timer(0.5).timeout
		var fodder: Enemy = FODDER.instantiate()
		fodder.global_position = player_pos + spawn_offset.rotated(randf_range(0, TAU))
		$Enemies.add_child(fodder)
	wave_complete = true
		
