extends Node


var player: Player
var slider: ChargeBar
var level: Level
var game_over = false
var enemy_kill_total = 0
var current_kills_to_target = 0.0
var current_kill_target = 12.0
var wave = 1
var start_time
enum ENEMY_TYPES {FODDER, CHARGELESS, PARASITE, RANGED}


func next_target(num):
	# uses the quadratic sequence 5x^2 + 4x + 3 to generate the next target
	return 5 * num * num + 4 * num + 3

func _process(delta: float) -> void:
	if current_kills_to_target == current_kill_target:
		wave += 1.0
		current_kill_target =  next_target(wave)
		current_kills_to_target = 0.0
