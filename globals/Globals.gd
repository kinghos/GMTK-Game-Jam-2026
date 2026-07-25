extends Node


var player: Player
var slider: ChargeBar
var shader_buffer_material: ShaderMaterial
var level: Level
var game_over = false
var enemy_kill_total = 0.0
var prev_target = 0.0
var current_kill_target = 11.0
var wave = 1
var powerups_gained = 0
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
	WEAPONS.SMG: preload("uid://br1xjya22rtki")
}
var blast_kb: float
var smg_kb: float
var smg_home_strength
var shotgun_bullets
var shotgun_spread
var rifle_pierce
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
var upgrade_counts = {
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

var weapon_icons = {
	WEAPONS.PISTOL: preload("uid://ctjxjn85mk3tr"),
	WEAPONS.SHOTGUN: preload("uid://bu2dxuikimkg"),
	WEAPONS.RIFLE: preload("uid://bc321hcosv7nw"),
	WEAPONS.SMG: preload("uid://br1xjya22rtki")
}

var weapon_names = {
	WEAPONS.PISTOL: "PISTOL",
	WEAPONS.SHOTGUN: "SHOTGUN",
	WEAPONS.RIFLE: "RIFLE",
	WEAPONS.SMG: "SMG"
}

var upgrade_icons_borderless = {
	WEAPON_UPGRADES.SHOTGUNSPREAD: preload("uid://be4778c3mjwqd"),
	WEAPON_UPGRADES.SHOTGUNBULLETS: preload("uid://brgohqmou0xqh"),
	WEAPON_UPGRADES.RIFLEPIERCE: preload("uid://41j2slimmync"),
	WEAPON_UPGRADES.RIFLESIZE: preload("uid://comido8v1fjj7"),
	WEAPON_UPGRADES.SMGHOME: preload("uid://dx4ea6wnr168s"),
	WEAPON_UPGRADES.SMGKB: preload("uid://p7oxaueh75dg")
}

var upgrade_icons_bordered = {
	WEAPON_UPGRADES.SHOTGUNSPREAD: preload("uid://bfeka2okr8xlh"),
	WEAPON_UPGRADES.SHOTGUNBULLETS: preload("uid://bmobtodtstesf"),
	WEAPON_UPGRADES.RIFLEPIERCE: preload("uid://5myc3kabyt6t"),
	WEAPON_UPGRADES.RIFLESIZE: preload("uid://nxsnbars8xdo"),
	WEAPON_UPGRADES.SMGHOME: preload("uid://67onhknybhgn"),
	WEAPON_UPGRADES.SMGKB: preload("uid://bubhqrja756tx")
}

var upgrade_names = {
	WEAPON_UPGRADES.SHOTGUNSPREAD: "SHOTGUN\nSPREAD",
	WEAPON_UPGRADES.SHOTGUNBULLETS: "SHOTGUN\nBULLETS",
	WEAPON_UPGRADES.RIFLEPIERCE: "RIFLE\nPIERCE",
	WEAPON_UPGRADES.RIFLESIZE: "RIFLE\nSIZE",
	WEAPON_UPGRADES.SMGHOME: "SMG\nHOME",
	WEAPON_UPGRADES.SMGKB: "SMG\nKB"
}
var upgrade_descriptions = {
	WEAPON_UPGRADES.SHOTGUNSPREAD: "INCREASES SPREAD ANGLE WHEN FIRING",
	WEAPON_UPGRADES.SHOTGUNBULLETS: "INCREASES NUMBER OF BULLETS FIRED",
	WEAPON_UPGRADES.RIFLEPIERCE: "INCREASES PIERCING OF BULLETS",
	WEAPON_UPGRADES.RIFLESIZE: "INCREASES SIZE OF BULLETS",
	WEAPON_UPGRADES.SMGHOME: "INCREASES HOMING OF BULLETS",
	WEAPON_UPGRADES.SMGKB: "INCREASES KNOCKBACK OF BULLETS"
}

var powerup_names = {
	POWERUPS.ATTACKSPEED: "ATTACK\nSPEED",
	POWERUPS.BULLETDMG: "BULLET\nDAMAGE",
	POWERUPS.BULLETSPEED: "BULLET\nSPEED",
	POWERUPS.ENERGYPACK: "ENERGY\nUP",
	POWERUPS.BLAST: "KNOCKBACK\nBLAST",
	POWERUPS.MOVESPEED: "MOVE\nSPEED"
}

var powerup_descriptions = {
	POWERUPS.ATTACKSPEED: "INCREASES THE FIRE RATE OF YOUR WEAPON",
	POWERUPS.BULLETDMG: "INCREASES BULLET DAMAGE",
	POWERUPS.BULLETSPEED: "INCREASE BULLET SPEED",
	POWERUPS.ENERGYPACK: "INCREASE THE MAXIMUM AMOUNT OF CHARGE YOU CAN HOLD",
	POWERUPS.BLAST: "INCREASES HOW FAR ENEMIES ARE KNOCKED BACK BY YOUR BLAST ABILITY",
	POWERUPS.MOVESPEED: "INCREASES MOVEMENT SPEED"
}

var weapon_descriptions = {
	WEAPONS.SHOTGUN: "FIRES BULLETS IN A SPREAD. USES MORE ENERGY",
	WEAPONS.RIFLE: "FIRES SLOW, POWERFUL BULLETS. USES MORE ENERGY",
	WEAPONS.SMG: "RAPIDLY FIRES SMALL, FASTER BULLETS"
}

var powerup_first_descriptions = {
	POWERUPS.BLAST: "UNLOCKS ABILITY TO KNOCK BACK ENEMIES"
}

var powerup_increases = {
	POWERUPS.ATTACKSPEED: -0.05,
	POWERUPS.BULLETDMG: 5,
	POWERUPS.BULLETSPEED: 50,
	POWERUPS.ENERGYPACK: 10,
	POWERUPS.BLAST: 0.1,
	POWERUPS.MOVESPEED: 20
}

var upgrade_increases = {
	WEAPON_UPGRADES.SHOTGUNSPREAD: 0.05,
	WEAPON_UPGRADES.SHOTGUNBULLETS: 1,
	WEAPON_UPGRADES.RIFLEPIERCE: 1,
	WEAPON_UPGRADES.RIFLESIZE: 0.2,
	WEAPON_UPGRADES.SMGHOME: 5,
	WEAPON_UPGRADES.SMGKB: 0.05,
}

func _ready() -> void: # reset variables on reload of scene
	game_over = false
	enemy_kill_total = 0
	prev_target = 0.0
	current_kill_target = next_target(1)
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
	weapon_bullet_sizes = {
		WEAPONS.PISTOL: 1.0,
		WEAPONS.SHOTGUN: 0.8,
		WEAPONS.RIFLE: 1.3,
		WEAPONS.SMG: 0.5
	}
	upgrade_counts = {
		WEAPON_UPGRADES.SHOTGUNSPREAD: 0,
		WEAPON_UPGRADES.SHOTGUNBULLETS: 0,
		WEAPON_UPGRADES.RIFLEPIERCE: 0,
		WEAPON_UPGRADES.RIFLESIZE: 0,
		WEAPON_UPGRADES.SMGHOME: 0,
		WEAPON_UPGRADES.SMGKB: 0
	}
	
	powerups_gained = 0
	bullet_damage = 10
	bullet_speed = 800.0
	blast_kb = 0.5
	shotgun_bullets = 4
	shotgun_spread = PI/12
	rifle_pierce = 0
	smg_kb = 0.05
	smg_home_strength = 500
	chosen_weapon = WEAPONS.PISTOL

func next_target(num):
	# uses the quadratic sequence 4x^2 + 4x + 3 to generate the next target
	return 4 * num * num + 4 * num + 3

func update_targets() -> void:
	if enemy_kill_total >= current_kill_target:
		wave += 1.0
		prev_target = current_kill_target
		current_kill_target =  next_target(wave)
		
func apply_powerup(powerup: int):
	var increase = powerup_increases[powerup]
	powerups_gained += 1
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

func apply_upgrade(upgrade: int):
	var increase = upgrade_increases[upgrade]
	powerups_gained += 1
	match upgrade:
		WEAPON_UPGRADES.SHOTGUNSPREAD:
			shotgun_spread += increase
		WEAPON_UPGRADES.SHOTGUNBULLETS:
			shotgun_bullets += increase
		WEAPON_UPGRADES.RIFLEPIERCE:
			rifle_pierce += increase
		WEAPON_UPGRADES.RIFLESIZE:
			weapon_bullet_sizes[WEAPONS.RIFLE] += increase
		WEAPON_UPGRADES.SMGHOME:
			smg_home_strength += increase
		WEAPON_UPGRADES.SMGKB:
			smg_kb += increase

func calc_powerup_effect(powerup: int):
	return powerup_counts[powerup] * powerup_increases[powerup]

func get_powerup_current_value(powerup: int) -> float:
	match powerup:
		POWERUPS.ATTACKSPEED:
			return player.gun.fire_rate
		POWERUPS.BULLETDMG:
			return float(bullet_damage)
		POWERUPS.BULLETSPEED:
			return bullet_speed
		POWERUPS.ENERGYPACK:
			return player.MAX_CHARGE
		POWERUPS.BLAST:
			return blast_kb
		POWERUPS.MOVESPEED:
			return player.WALK_SPEED
	return 0.0

func get_upgrade_current_value(powerup: int) -> float:
	match powerup:
		WEAPON_UPGRADES.SHOTGUNSPREAD:
			return shotgun_spread
		WEAPON_UPGRADES.SHOTGUNBULLETS:
			return shotgun_bullets
		WEAPON_UPGRADES.RIFLEPIERCE:
			return rifle_pierce
		WEAPON_UPGRADES.RIFLESIZE:
			return weapon_bullet_sizes[WEAPONS.RIFLE]
		WEAPON_UPGRADES.SMGHOME:
			return smg_home_strength
		WEAPON_UPGRADES.SMGKB:
			return smg_kb
	return 0.0

func print_powerup_values(): # for debugging
	print("Powerup values:")
	print("ATTACK SPEED ", player.gun.fire_rate)
	print("BULLET DAMAGE ",bullet_damage)
	print("BULLET SPEED ", bullet_speed)
	print("ENERGY PACK ", player.MAX_CHARGE)
	print("KNOCKBACK BLAST ", blast_kb)
	print("WALK SPEED ", player.WALK_SPEED, " SPRINT SPEED:", player.SPRINT_SPEED)

func get_associated_upgrades(weapon: int):
	var selection
	match weapon:
		Globals.WEAPONS.SHOTGUN:
			selection = [0, 1]
		Globals.WEAPONS.RIFLE:
			selection = [2, 3]
		Globals.WEAPONS.SMG:
			selection = [4, 5]
	return selection
