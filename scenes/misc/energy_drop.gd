extends Area2D

@export var energy_gained = 20
@export var pull_speed = 80
var pulling = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if pulling:
		var direction = Globals.player.global_position - global_position
		direction = direction.normalized()
		var tween = get_tree().create_tween()
		var angle = PI / 6
		if direction.x < 0:
			angle = -PI / 6
		tween.tween_property(self, "rotation", angle, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
		global_position += direction * pull_speed * delta
	else:
		if rotation != 0:
			var tween = get_tree().create_tween()
			tween.tween_property(self, "rotation", 0, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)


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
