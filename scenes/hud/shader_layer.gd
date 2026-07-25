extends CanvasLayer



func _ready() -> void:
	Globals.shader_buffer_material = $ShaderBuffer.material as ShaderMaterial
	$Instructions.visible = not get_tree().current_scene.name == "GameOver"
