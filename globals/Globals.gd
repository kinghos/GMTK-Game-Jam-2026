extends Node


var player: Player
var slider: ChargeBar
var level: Level
var game_over = false
var enemy_kill_total = 0
var current_kill_target = 12
var wave = 1
var start_time
enum ENEMY_TYPES {FODDER, CHARGELESS, PARASITE, RANGED}


func next_target(num):
	# uses the quadratic sequence 5x^2 + 4x + 3 to generate the next target
	return 5 * num * num + 4 * num + 3
