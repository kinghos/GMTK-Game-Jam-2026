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
var start_time: int
var bullet_damage: int = 50
var bullet_speed: float = 800.0
var blast_kb: float = 0.5
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

var powerup_increases = {
	POWERUPS.ATTACKSPEED: 0.05,
	POWERUPS.BULLETDMG: 5,
	POWERUPS.BULLETSPEED: 50,
	POWERUPS.ENERGYPACK: 10,
	POWERUPS.BLAST: 0.1,
	POWERUPS.MOVESPEED: 20
}

func _ready() -> void:
	game_over = false
	enemy_kill_total = 0
	current_kills_to_target = 0.0
	current_kill_target = 12
	wave = 1
	start_time = Time.get_ticks_msec()
	powerup_counts = {
		POWERUPS.ATTACKSPEED: 0,
		POWERUPS.BULLETDMG: 0,
		POWERUPS.BULLETSPEED: 0,
		POWERUPS.ENERGYPACK: 0,
		POWERUPS.BLAST: 0,
		POWERUPS.MOVESPEED: 0,
	}
	weapon_upgrade_counts = {
	WEAPON_UPGRADES.SHOTGUNSPREAD: 0,
	WEAPON_UPGRADES.SHOTGUNBULLETS: 0,
	WEAPON_UPGRADES.RIFLEPIERCE: 0,
	WEAPON_UPGRADES.RIFLESIZE: 0,
	WEAPON_UPGRADES.SMGHOME: 0,
	WEAPON_UPGRADES.SMGKB: 0
	}
	
	bullet_damage = 50
	bullet_speed = 800.0
	blast_kb = 0.5

func next_target(num):
	# uses the quadratic sequence 5x^2 + 4x + 3 to generate the next target
	return 5 * num * num + 4 * num + 3

func update_targets() -> void:
	if current_kills_to_target == current_kill_target:
		wave += 1.0
		current_kill_target =  next_target(wave)
		current_kills_to_target = 0.0
		
func apply_powerup(powerup: int):
	var increase = powerup_increases[powerup]
	match powerup:
		POWERUPS.ATTACKSPEED:
			player.gun.fire_rate += increase
		POWERUPS.BULLETDMG:
			bullet_damage += increase
		POWERUPS.BULLETSPEED:
			bullet_speed += increase
		POWERUPS.ENERGYPACK:
			player.MAX_CHARGE += increase
		POWERUPS.BLAST:
			blast_kb += increase
		POWERUPS.MOVESPEED:
			player.WALK_SPEED += increase
			player.SPRINT_SPEED += increase

func print_powerup_values(): # for debugging
	print("Powerup values:")
	print("ATTACK SPEED ", player.gun.fire_rate)
	print("BULLET DAMAGE ",bullet_damage)
	print("BULLET SPEED ", bullet_speed)
	print("ENERGY PACK ", player.MAX_CHARGE)
	print("KNOCKBACK BLAST ", blast_kb)
	print("WALK SPEED ", player.WALK_SPEED, " SPRINT SPEED:", player.SPRINT_SPEED)
