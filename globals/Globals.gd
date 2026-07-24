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
var bullet_damage: int = 10
var weapon_damages = {
	WEAPONS.PISTOL: 10,
	WEAPONS.SHOTGUN: 7,
	WEAPONS.RIFLE: 15,
	WEAPONS.SMG: 5
}
var bullet_speed: float = 800.0
var weapon_bullet_speeds = {
	WEAPONS.PISTOL: 800,
	WEAPONS.SHOTGUN: 700,
	WEAPONS.RIFLE: 1100,
	WEAPONS.SMG: 900
}
var weapon_attack_speeds = {
	WEAPONS.PISTOL: 0.6,
	WEAPONS.SHOTGUN: 0.65,
	WEAPONS.RIFLE: 1.0,
	WEAPONS.SMG: 0.2
}
var weapon_bullet_sizes = {
	WEAPONS.PISTOL: 1.0,
	WEAPONS.SHOTGUN: 0.8,
	WEAPONS.RIFLE: 1.3,
	WEAPONS.SMG: 0.5
}
var weapon_sprites = {
	WEAPONS.PISTOL: preload("uid://ctjxjn85mk3tr"),
	WEAPONS.SHOTGUN: preload("uid://bu2dxuikimkg"),
	WEAPONS.RIFLE: preload("uid://ym68aq313xlq"),
	WEAPONS.SMG: preload("uid://ym68aq313xlq")
}
var blast_kb: float = 0.5
var shotgun_bullets = 4
enum ENEMY_TYPES {FODDER, CHARGELESS, PARASITE, RANGED}

enum POWERUPS {ATTACKSPEED, BULLETDMG, BULLETSPEED, ENERGYPACK, BLAST, MOVESPEED}
enum WEAPON_UPGRADES {SHOTGUNSPREAD, SHOTGUNBULLETS, RIFLEPIERCE, RIFLESIZE, SMGHOME, SMGKB}
enum WEAPONS {PISTOL, SHOTGUN, RIFLE, SMG}
var chosen_weapon = WEAPONS.RIFLE
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
	POWERUPS.ATTACKSPEED: "ATTACK\nSPEED",
	POWERUPS.BULLETDMG: "BULLET\nDAMAGE",
	POWERUPS.BULLETSPEED: "BULLET\nSPEED",
	POWERUPS.ENERGYPACK: "ENERGY\nUP",
	POWERUPS.BLAST: "KNOCKBACK\nBLAST",
	POWERUPS.MOVESPEED: "MOVE\nSPEED"
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
	
	bullet_damage = 10
	bullet_speed = 800.0
	blast_kb = 0.5
	shotgun_bullets = 4
	#chosen_weapon = WEAPONS.PISTOL

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
			pass
		POWERUPS.BULLETDMG:
			pass
		POWERUPS.BULLETSPEED:
			pass
		POWERUPS.ENERGYPACK:
			player.MAX_CHARGE += increase
		POWERUPS.BLAST:
			blast_kb += increase
		POWERUPS.MOVESPEED:
			player.WALK_SPEED += increase
			player.SPRINT_SPEED += increase

func calc_powerup_effect(powerup: int):
	return powerup_counts[powerup] * powerup_increases[powerup]

func print_powerup_values(): # for debugging
	print("Powerup values:")
	print("ATTACK SPEED ", player.gun.fire_rate)
	print("BULLET DAMAGE ",bullet_damage)
	print("BULLET SPEED ", bullet_speed)
	print("ENERGY PACK ", player.MAX_CHARGE)
	print("KNOCKBACK BLAST ", blast_kb)
	print("WALK SPEED ", player.WALK_SPEED, " SPRINT SPEED:", player.SPRINT_SPEED)
