extends Node2D
class_name Level

@onready var spawn_timer: Timer = $SpawnTimer
@onready var floor: TileMapLayer = $TileMap/Floor
@onready var enemy_intro: CanvasLayer = $EnemyIntro

var spawn_group_size = 3
var spawn_radius_min = 350
var spawn_radius_max = 550

const ENEMIES = {
	"fodder": {
		"scene": preload("res://scenes/enemies/fodder.tscn"),
		"cost": 1,
		"base_weight": 80,
		"decay": 5
	},
	"lightbomb": {
		"scene": preload("res://scenes/enemies/lightbomb.tscn"),
		"cost": 3,
		"base_weight": 20,
		"growth": 5,
		"start_wave": 2
	},
	"toaster": {
		"scene": preload("res://scenes/enemies/toaster.tscn"),
		"cost": 5,
		"base_weight": 10,
		"growth": 4,
		"start_wave": 3,
		"requires_seen": "lightbomb"
	},
	"batterypion": {
		"scene": preload("uid://dxrfr1il2fdvy"),
		"cost": 3,
		"base_weight": 5,
		"growth": 4,
		"start_wave": 5,
		"requires_seen": "toaster"
	}
}

var spawning_wave = false
var wave_number = 0
var enemy_count = 0
var last_amount_spawned = 0

var spawn_queue = []

func _ready() -> void:
	Globals.level = self
	Globals.pause_menu = $PauseMenu
	Globals.prevent_pause = false
	Music.play_music(Music.MAIN_THEME)
	Music.volume_db = 0
	start_wave()

func _exit_tree() -> void:
	Globals.prevent_pause = true

func _process(delta: float) -> void:
	enemy_count = get_tree().get_nodes_in_group("Enemies").size()
	
	if spawning_wave: return
	if Globals.game_over: return
	
	if enemy_count <= min(5, int(last_amount_spawned * 0.25)):
		start_wave()

func start_wave():
	print("starting wave")
	wave_number += 1
	spawn_group_size = floori(3 * pow(1 + 0.1/100, 100 * wave_number)) # magic formula
	spawning_wave = true
	build_wave()
	print("spawning this number: %d" % spawn_queue.size())
	last_amount_spawned = spawn_queue.size()
	_on_spawn_timer_timeout()
	spawn_timer.start()

func build_wave():
	spawn_queue.clear()
	
	var budget = get_wave_budget()
	while budget > 0:
		var enemy = choose_enemy()
		if enemy.cost <= budget:
			spawn_queue.append(enemy.scene)
			budget -= enemy.cost

func get_wave_budget():
	return 3 + pow(10, wave_number/5)
	
func choose_enemy():
	var total_weight = 0.0
	var current_weights = {}
	
	for key in ENEMIES.keys():
		var enemy = ENEMIES[key]
		var weight = 0
		
		if !enemy.has("start_wave") or wave_number >= enemy.start_wave:
			weight = enemy.base_weight
		
		if enemy.has("growth"):
			if wave_number > enemy.start_wave:
				weight += (wave_number - enemy.start_wave + 1) * enemy.growth
		
		if enemy.has("decay"):
			weight = max(20, weight - wave_number * enemy.decay)
		
		if enemy.has("requires_seen") and !Globals.has_seen(enemy.requires_seen):
			weight = 0
		
		current_weights[key] = weight
		total_weight += weight
	
	var pick = randi_range(1, total_weight)
	
	for key in ENEMIES.keys():
		pick -= current_weights[key]
		
		if pick <= 0:
			return ENEMIES[key]
	
	return ENEMIES["fodder"]

func spawn_enemy(scene: PackedScene):
	if not Globals.player: return
	
	var enemy = scene.instantiate()
	enemy.speed *= 1 + (wave_number / 50.0)
	var spawn_pos = Vector2.ZERO
	var valid_spawn = false
	var attempts = 0
	var max_attempts = 100

	while not valid_spawn and attempts < max_attempts:
		attempts += 1
		var angle = randf() * TAU
		var distance = randf_range(spawn_radius_min, spawn_radius_max)
		spawn_pos = Globals.player.global_position + Vector2.RIGHT.rotated(angle) * distance
		
		var local_pos = floor.to_local(spawn_pos)
		var map_pos = floor.local_to_map(local_pos)
		
		var tile_data = floor.get_cell_tile_data(map_pos)
		
		if tile_data:
			var is_spawnable = tile_data.get_custom_data("spawnable")
			if is_spawnable != false:
				valid_spawn = true
	
	if not valid_spawn:
		print("We avoided a crash :)")

	enemy.global_position = spawn_pos
	$Enemies.add_child(enemy)

func _on_spawn_timer_timeout() -> void:
	for i in spawn_group_size:
		if spawn_queue.is_empty():
			spawning_wave = false
			spawn_timer.stop()
			return
		var scene = spawn_queue.pop_front()
		spawn_enemy(scene)
		await get_tree().create_timer(0.35).timeout
	spawn_timer.start()
