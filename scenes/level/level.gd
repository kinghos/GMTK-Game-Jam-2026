extends Node2D
class_name Level
const FODDER = preload("uid://cyaef5g41qd5j")

@onready var spawn_timer: Timer = $SpawnTimer
var spawn_num = 10
var spawning_wave = false
var spawn_offset: Vector2 = Vector2(400, 400)

var enemy_count = 0.0
var last_amount_spawned = 0.0

# on new spawn: decrease fodder, increase everything else
# use enemytypes in global
var weights = {
	# Fodder: 0.9
	#
}

func _ready() -> void:
	Globals.level = self
	spawn_wave()

func _process(delta: float) -> void:
	enemy_count = get_tree().get_nodes_in_group("Enemies").size()
	if not spawning_wave and not Globals.game_over:
		if enemy_count / last_amount_spawned <= 0.25:
			spawn_wave()
			spawn_timer.start()

func spawn_wave():
	spawning_wave = true
	
	var player_pos = Globals.player.global_position
	
	for i in spawn_num:
		var fodder: Enemy = FODDER.instantiate()
		fodder.global_position = player_pos + spawn_offset.rotated(randf_range(0, TAU))
		$Enemies.add_child(fodder)
	
	spawning_wave = false
	last_amount_spawned = spawn_num
	spawn_num = spawn_num * 1.5

func _on_spawn_timer_timeout() -> void:
	spawn_wave()
