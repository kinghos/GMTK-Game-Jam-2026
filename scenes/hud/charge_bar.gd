extends HSlider
class_name ChargeBar

@onready var animation_player: AnimationPlayer = %AnimationPlayer

var red_stylebox = StyleBoxFlat.new()
var flash_timer = 0.0

var displayed_charge = -1.0

func _ready() -> void:
	Globals.slider = self
	prepare_stylebox()

func prepare_stylebox():
	red_stylebox.bg_color = Color(1, 0, 0, 1)
	red_stylebox.set_corner_radius_all(4)
	red_stylebox.corner_detail = 6
	red_stylebox.set_content_margin_all(4)

func _process(delta: float) -> void:
	flash_timer += delta
	if Globals.player:
		max_value = Globals.player.MAX_CHARGE * 1000
		var target_charge = Globals.player.charge * 1000
		
		
		if displayed_charge == -1:
			displayed_charge = target_charge
		
		var speed = 15.0 + (1.0 - ratio) * 30.0
		displayed_charge = lerp(displayed_charge, target_charge, delta * speed)
		value = displayed_charge
	
	var low_charge_ratio = clampf(ratio, 0.0, 0.5)
	
	if ratio <= 0.3 and ratio > 0.2:
		animation_player.play("first_warning")
	elif ratio <= 0.2 and ratio > 0.1:
		animation_player.play("second_warning")
	elif ratio <= 0.1:
		animation_player.play("third_warning")
	else:
		animation_player.play("RESET")
		animation_player.stop()
	
	if low_charge_ratio <= 0.25:
		flash_red()
	else:
		reset_red()
	var smat = Globals.shader_buffer_material
	smat.set_shader_parameter("noise_amount", remap(low_charge_ratio, 0.0, 0.25, 0.2, 0.05))
	smat.set_shader_parameter("vignette_intensity", remap(low_charge_ratio, 0.0, 0.25, 1.0, 0.4))
	smat.set_shader_parameter("vignette_amount", remap(low_charge_ratio, 0.0, 0.25, 0.8, 0.6))

func flash_red():
	if flash_timer > 0.5:
		if has_theme_stylebox_override("grabber_area"):
			reset_red()
		else:
			add_theme_stylebox_override("grabber_area", red_stylebox)
		flash_timer = 0.0

func reset_red():
	remove_theme_stylebox_override("grabber_area")

func get_grabber_position() -> Vector2:
	var slider_width = size.x
	var grabber_x = slider_width * ratio
	var grabber_y = size.y / 2.0
	
	return Vector2(grabber_x, grabber_y)
