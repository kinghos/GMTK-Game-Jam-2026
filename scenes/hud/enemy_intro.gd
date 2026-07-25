extends CanvasLayer

@onready var mask = $Mask
@onready var title = $Title
@onready var tagline = $Title/Tagline
@onready var cinematic_cam: Camera2D = $Camera2D

var player_cam: Camera2D
var target_enemy: Node2D
var target_radius: float

var in_progress: bool = false

func _ready() -> void:
	player_cam = Globals.player.camera_2d
	visible = false
	title.modulate.a = 0.0
	tagline.modulate.a = 0.0

func play_intro(enemy: Node2D, enemy_name: String, tagline_text: String) -> void:
	in_progress = true
	target_enemy = enemy
	title.text = enemy_name
	title.add_theme_font_size_override("normal_font_size", enemy.intro_name_font_size)
	tagline.text = tagline_text
	tagline.offset_transform_position_ratio.y = enemy.intro_tagline_position_ratio_y
	title.modulate.a = 0.0
	tagline.modulate.a = 0.0
	visible = true

	cinematic_cam.global_position = player_cam.global_position
	cinematic_cam.zoom = player_cam.zoom
	player_cam.enabled = false
	cinematic_cam.enabled = true

	var sprite = target_enemy.sprite_2d
	var frame_texture = sprite.sprite_frames.get_frame_texture(sprite.animation, 0)
	var sprite_size = frame_texture.get_size() * sprite.scale
	var max_enemy_dimension = max(sprite_size.x, sprite_size.y)
	var screen_height = get_viewport().get_visible_rect().size.y
	target_radius = ((max_enemy_dimension * 3) / screen_height) * 0.5 + 0.05

	var start_pos = cinematic_cam.global_position
	var start_zoom = cinematic_cam.zoom

	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)

	tween.tween_method(
		func(v: float): update_intro_frame(v, start_pos, start_zoom, 1.6, 3.0),
		0.0, 1.0, 0.6
	)

	tween.tween_callback(pause_and_show_ui)
	tween.tween_interval(1.5)
	tween.tween_callback(start_return)

func update_intro_frame(v: float, start_pos: Vector2, start_zoom: Vector2, zoom_amount: float, start_radius: float) -> void:
	var dynamic_target = Globals.player.global_position.lerp(target_enemy.global_position, 0.7)
	cinematic_cam.global_position = start_pos.lerp(dynamic_target, v)
	cinematic_cam.zoom = start_zoom.lerp(Vector2(zoom_amount, zoom_amount), v)
	mask.material.set("shader_parameter/radius", lerp(start_radius, target_radius, v))
	update_mask_center()

func update_mask_center() -> void:
	var screen_pos = target_enemy.get_global_transform_with_canvas().origin
	var screen_size = get_viewport().get_visible_rect().size
	mask.material.set("shader_parameter/center", screen_pos / screen_size)

func pause_and_show_ui() -> void:
	get_tree().paused = true
	update_mask_center()
	position_intro_text()

	var fade_in = create_tween()
	fade_in.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	fade_in.set_parallel(true)
	fade_in.tween_property(title, "modulate:a", 1.0, 0.25)
	fade_in.tween_property(tagline, "modulate:a", 1.0, 0.25).set_delay(0.1)

func position_intro_text() -> void:
	var screen_size = get_viewport().get_visible_rect().size
	var enemy_screen_pos = target_enemy.get_global_transform_with_canvas().origin

	var target_x: float
	if enemy_screen_pos.x < screen_size.x * 0.5:
		target_x = screen_size.x * 0.6 - (title.size.x * 0.2)
	else:
		target_x = screen_size.x * 0.4 - (title.size.x * 0.6)

	var target_y: float
	if enemy_screen_pos.y < screen_size.y * 0.5:
		target_y = screen_size.y * 0.3
	else:
		target_y = screen_size.y * 0.15

	title.global_position = Vector2(target_x, target_y)

func start_return() -> void:
	var fade_out = create_tween()
	fade_out.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	fade_out.set_parallel(true)
	fade_out.tween_property(title, "modulate:a", 0.0, 0.15)
	fade_out.tween_property(tagline, "modulate:a", 0.0, 0.15)
	fade_out.chain().tween_callback(unpause_and_return)

func unpause_and_return() -> void:
	get_tree().paused = false

	var start_pos = cinematic_cam.global_position
	var start_zoom = cinematic_cam.zoom
	var start_radius = mask.material.get("shader_parameter/radius")
	var return_duration := 1.0

	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_method(
		func(v: float):
			cinematic_cam.global_position = start_pos.lerp(player_cam.global_position, v)
			cinematic_cam.zoom = start_zoom.lerp(player_cam.zoom, v)
			mask.material.set("shader_parameter/radius", lerp(start_radius, 3.0, v)),
		0.0, 1.0, return_duration
	)
	tween.tween_callback(finish_intro)


func finish_intro() -> void:
	visible = false
	player_cam.enabled = true
	cinematic_cam.enabled = false
	in_progress = false
