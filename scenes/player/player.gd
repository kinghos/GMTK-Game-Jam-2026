extends CharacterBody2D
class_name Player

var distance_since_last_ejaculated = 0
var health_that_goes_down_with_the_mystery_undecided_ejaculate = 100
const IDLE_EJACULATING = 1.0
const MOVING_EJACULATING = 6.0
const MAX_SPEED = 400.0

const HE_FUCKING_EXPLODED_NOOOOO = preload("res://scenes/player/he_fucking_explodes_NOOOOOOOO.tscn")

var ejaculate_timer = 0

func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("Left", "Right", "Up", "Down")
	velocity = MAX_SPEED * direction
	move_and_slide()
	
	var speed_percent = clamp(velocity.length() / MAX_SPEED, 0.0, 1.0)
	health_that_goes_down_with_the_mystery_undecided_ejaculate -= (IDLE_EJACULATING + MOVING_EJACULATING * speed_percent) * delta
	
	if health_that_goes_down_with_the_mystery_undecided_ejaculate <= 0:
		die()
		return
	
	ejaculate_timer += delta
	
	var interval = lerp(1.2, 0.08, speed_percent)
	
	if ejaculate_timer >= interval:
		spawn_ejaculate()
		ejaculate_timer = 0

func spawn_ejaculate():
	var new_ejaculate = Ejaculate.create_ejaculate(global_position)
	get_tree().current_scene.add_child(new_ejaculate)

func die():
	var NOOOOOOOOOOO = HE_FUCKING_EXPLODED_NOOOOO.instantiate()
	NOOOOOOOOOOO.global_position = global_position
	get_tree().current_scene.add_child(NOOOOOOOOOOO)
