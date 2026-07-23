extends HSlider
class_name ChargeBar

@onready var shader_buffer: ColorRect = $"../ShaderBuffer"
@onready var smat = shader_buffer.material as ShaderMaterial

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
		
		displayed_charge = lerp(displayed_charge, target_charge, delta * 15)
		value = displayed_charge
	
	var low_charge_ratio = clampf(ratio, 0.0, 0.25)
	
	if low_charge_ratio < 0.25:
		flash_red()

	smat.set_shader_parameter("noise_amount", remap(low_charge_ratio, 0.0, 0.25, 0.12, 0.03))
	smat.set_shader_parameter("vignette_intensity", remap(low_charge_ratio, 0.0, 0.25, 1.0, 0.4))

func flash_red():
	if flash_timer > 0.5:
		if has_theme_stylebox_override("grabber_area"):
			remove_theme_stylebox_override("grabber_area")
		else:
			add_theme_stylebox_override("grabber_area", red_stylebox)
		flash_timer = 0.0

func get_grabber_position() -> Vector2:
	var slider_width = size.x
	var grabber_x = slider_width * ratio
	var grabber_y = size.y / 2.0
	
	return Vector2(grabber_x, grabber_y)
