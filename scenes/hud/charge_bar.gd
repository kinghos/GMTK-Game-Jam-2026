extends HSlider

@onready var shader_buffer: ColorRect = $"../ShaderBuffer"
@onready var smat = shader_buffer.material as ShaderMaterial

func _process(delta: float) -> void:
	if Globals.player:
		max_value = Globals.player.MAX_CHARGE * 1000
		value = Globals.player.charge * 1000
	
	var normalised = value / max_value
	var low_charge_ratio = clampf(normalised, 0.0, 0.25)

	smat.set_shader_parameter("noise_amount", remap(low_charge_ratio, 0.0, 0.25, 0.12, 0.03))
	smat.set_shader_parameter("vignette_intensity", remap(low_charge_ratio, 0.0, 0.25, 1.0, 0.4))
