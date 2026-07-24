extends CanvasLayer



func _ready() -> void:
	Globals.shader_buffer_material = $ShaderBuffer.material as ShaderMaterial
