extends Area2D

@export var energy_gained = 30
@export var pull_speed = 80
var pulling = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if pulling:
		var to_player = Globals.player.global_position - global_position
		var distance = to_player.length()
		
		if distance > 1.0:
			var direction = to_player / distance
			
			# x/distance, x is cap, needs tweaking
			var distance_multiplier = 1.0 + (50.0 / distance)
			
			var current_speed = pull_speed * distance_multiplier
			global_position += direction * current_speed * delta
			
		var target_angle = PI / 6 if to_player.x > 0 else -PI / 6
		rotation = lerp_angle(rotation, target_angle, 10.0 * delta)
	else:
		if not is_equal_approx(rotation, 0.0):
			rotation = lerp_angle(rotation, 0.0, 10.0 * delta)

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		if not body.debuffed:
			body.energy_gain(energy_gained)
			queue_free()


func _on_pull_radius_body_entered(body: Node2D) -> void:
	if body is Player:
		if not body.debuffed:
			pulling = true


func _on_pull_radius_body_exited(body: Node2D) -> void:
	if body is Player:
		pulling = false
