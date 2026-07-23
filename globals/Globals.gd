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

enum POWERUPS {ATTACKSPEED, BULLETDMG, BULLETSPEED, ENERGYPACK, BLAST, MOVESPEED, SHOTGUNSPREAD,
			   SHOTGUNBULLETS, RIFLEPIERCE, RIFLESIZE, SMGHOME, SMGKB}
enum WEAPONS {PISTOL, SHOTGUN, RIFLE, SMG}
var chosen_weapon = WEAPONS.PISTOL
var powerup_counts = {
	POWERUPS.ATTACKSPEED: 0,
	POWERUPS.BULLETDMG: 0,
	POWERUPS.BULLETSPEED: 0,
	POWERUPS.ENERGYPACK: 0,
	POWERUPS.BLAST: 0,
	POWERUPS.MOVESPEED: 0,
	POWERUPS.SHOTGUNSPREAD: 0,
	POWERUPS.SHOTGUNBULLETS: 0,
	POWERUPS.RIFLEPIERCE: 0,
	POWERUPS.RIFLESIZE: 0,
	POWERUPS.SMGHOME: 0,
	POWERUPS.SMGKB: 0
}

func _ready() -> void:
	game_over = false
	enemy_kill_total = 0
	current_kills_to_target = 0.0
	current_kill_target = 12
	wave = 1
	start_time = Time.get_ticks_msec()
	var powerup_counts = {
		POWERUPS.ATTACKSPEED: 0,
		POWERUPS.BULLETDMG: 0,
		POWERUPS.BULLETSPEED: 0,
		POWERUPS.ENERGYPACK: 0,
		POWERUPS.BLAST: 0,
		POWERUPS.MOVESPEED: 0,
		POWERUPS.SHOTGUNSPREAD: 0,
		POWERUPS.SHOTGUNBULLETS: 0,
		POWERUPS.RIFLEPIERCE: 0,
		POWERUPS.RIFLESIZE: 0,
		POWERUPS.SMGHOME: 0,
		POWERUPS.SMGKB: 0
	}

func next_target(num):
	# uses the quadratic sequence 5x^2 + 4x + 3 to generate the next target
	return 5 * num * num + 4 * num + 3

func _process(delta: float) -> void:
	if current_kills_to_target == current_kill_target:
		wave += 1.0
		current_kill_target =  next_target(wave)
		current_kills_to_target = 0.0
