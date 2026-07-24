extends Node


var player: Player
var slider: ChargeBar
var shader_buffer_material: ShaderMaterial
var level: Level
var game_over = false
var enemy_kill_total = 0
var current_kills_to_target = 0.0
var current_kill_target = 12.0
var wave = 1
var start_time
enum ENEMY_TYPES {FODDER, CHARGELESS, PARASITE, RANGED}

enum POWERUPS {ATTACKSPEED, BULLETDMG, BULLETSPEED, ENERGYPACK, BLAST, MOVESPEED}
enum WEAPON_UPGRADES {SHOTGUNSPREAD, SHOTGUNBULLETS, RIFLEPIERCE, RIFLESIZE, SMGHOME, SMGKB}
enum WEAPONS {PISTOL, SHOTGUN, RIFLE, SMG}
var chosen_weapon = WEAPONS.PISTOL
var powerup_counts = {
	POWERUPS.ATTACKSPEED: 0,
	POWERUPS.BULLETDMG: 0,
	POWERUPS.BULLETSPEED: 0,
	POWERUPS.ENERGYPACK: 0,
	POWERUPS.BLAST: 0,
	POWERUPS.MOVESPEED: 0
}
var weapon_upgrade_counts = {
	WEAPON_UPGRADES.SHOTGUNSPREAD: 0,
	WEAPON_UPGRADES.SHOTGUNBULLETS: 0,
	WEAPON_UPGRADES.RIFLEPIERCE: 0,
	WEAPON_UPGRADES.RIFLESIZE: 0,
	WEAPON_UPGRADES.SMGHOME: 0,
	WEAPON_UPGRADES.SMGKB: 0
}

var powerup_icons = {
	POWERUPS.ATTACKSPEED: preload("uid://c48rt14572q2o"),
	POWERUPS.BULLETDMG: preload("uid://im2o0b7ne0yv"),
	POWERUPS.BULLETSPEED: preload("uid://d141muxcqgbr8"),
	POWERUPS.ENERGYPACK: preload("uid://bl1ntkwsaqreq"),
	POWERUPS.BLAST: preload("uid://7kr1m1x5mr8p"),
	POWERUPS.MOVESPEED: preload("uid://csxwbbisxkkt3")
}

var powerup_names = {
	POWERUPS.ATTACKSPEED: "ATTACK SPEED",
	POWERUPS.BULLETDMG: "BULLET DAMAGE",
	POWERUPS.BULLETSPEED: "BULLET SPEED",
	POWERUPS.ENERGYPACK: "ENERGY UP",
	POWERUPS.BLAST: "KNOCKBACK BLAST",
	POWERUPS.MOVESPEED: "MOVE SPEED"
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
	}
	var weapon_upgrade_counts = {
	WEAPON_UPGRADES.SHOTGUNSPREAD: 0,
	WEAPON_UPGRADES.SHOTGUNBULLETS: 0,
	WEAPON_UPGRADES.RIFLEPIERCE: 0,
	WEAPON_UPGRADES.RIFLESIZE: 0,
	WEAPON_UPGRADES.SMGHOME: 0,
	WEAPON_UPGRADES.SMGKB: 0
	}

func next_target(num):
	# uses the quadratic sequence 5x^2 + 4x + 3 to generate the next target
	return 5 * num * num + 4 * num + 3

func update_targets() -> void:
	if current_kills_to_target == current_kill_target:
		wave += 1.0
		current_kill_target =  next_target(wave)
		current_kills_to_target = 0.0
