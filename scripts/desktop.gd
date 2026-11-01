extends Node2D

const ROOM_W := 1100.0
const ROOM_H := 480.0
const FLOOR := Rect2(0, 400, 1100, 90)

var _enter := 0.0
var _window: CanvasLayer
var _hint: Label
var _clock: Label

@onready var player: CharacterBody2D = $Player
@onready var letters: Area2D = $Letters
@onready var pictures: Area2D = $Pictures


func _ready() -> void:
	_hint = $Hud/Hint
	_clock = $Hud/Clock
	var camera := $Player/Camera as Camera2D
	camera.limit_left = 0
	camera.limit_top = 0
	camera.limit_right = int(ROOM_W)
	camera.limit_bottom = 640
	Props.add_solid(self, FLOOR, Color("2a3142"), Color("f4f5f8"), false)
	Props.add_wall(self, Rect2(-28, -80, 28, 820))
	Props.add_wall(self, Rect2(ROOM_W, -80, 28, 820))
	_add_dock()
	_build_window()
	_tick_clock()
	if Session.letters_open:
		Session.letters_open = false
		_show_letters()


func _process(_delta: float) -> void:
	_tick_clock()


func _physics_process(delta: float) -> void:
	if _window.visible:
		return
	if letters.overlaps_body(player):
		_enter += delta
		_hint.text = "Opening Letters"
		if _enter > 0.3:
			_enter = 0.0
			_show_letters()
	elif pictures.overlaps_body(player):
		_enter = 0.0
		_hint.text = "Pictures is locked"
	else:
		_enter = 0.0
		_hint.text = "Run into a folder"


func _show_letters() -> void:
	_window.visible = true
	player.velocity = Vector2.ZERO
	player.set_physics_process(false)
	Input.action_release("move_left")
	Input.action_release("move_right")
	Input.action_release("jump")
	_hint.text = ""


func _close_letters() -> void:
	_window.visible = false
	player.set_physics_process(true)
	_hint.text = "Run into a folder"


func _open_note() -> void:
	get_tree().change_scene_to_file("res://scenes/letter.tscn")


func _tick_clock() -> void:
	var now := Time.get_time_string_from_system().substr(0, 5)
	if _clock.text != now:
		_clock.text = now


func _add_dock() -> void:
	var dock := Polygon2D.new()
	dock.z_index = 1
	dock.color = Color(0.95, 0.96, 0.98, 0.94)
	dock.polygon = _chamfer(Rect2(28, 388, ROOM_W - 56, 36), 14)
	add_child(dock)


func _build_window() -> void:
	_window = CanvasLayer.new()
	_window.layer = 20
	_window.visible = false
	add_child(_window)

	var dim := ColorRect.new()
	dim.color = Color(0.07, 0.09, 0.14, 0.38)
	dim.mouse_filter = Control.MOUSE_FILTER_STOP
	_window.add_child(dim)
	dim.set_anchors_preset(Control.PRESET_FULL_RECT)

	var panel := Panel.new()
	panel.set_anchors_preset(Control.PRESET_CENTER)
	panel.offset_left = -150
	panel.offset_top = -100
	panel.offset_right = 150
	panel.offset_bottom = 100
	panel.mouse_filter = Control.MOUSE_FILTER_STOP
	var plate := StyleBoxFlat.new()
	plate.bg_color = Color(0.97, 0.97, 0.98, 0.98)
	plate.set_corner_radius_all(18)
	plate.shadow_color = Color(0, 0, 0, 0.28)
	plate.shadow_size = 18
	plate.shadow_offset = Vector2(0, 8)
	panel.add_theme_stylebox_override("panel", plate)
	_window.add_child(panel)

	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 8)
	panel.add_child(box)
	box.set_anchors_preset(Control.PRESET_FULL_RECT)
	box.offset_left = 14
	box.offset_top = 10
	box.offset_right = -14
	box.offset_bottom = -12

	var title_row := HBoxContainer.new()
	box.add_child(title_row)
	var title := Label.new()
	title.text = "Letters"
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title.add_theme_font_size_override("font_size", 16)
	title.add_theme_color_override("font_color", Color(0.16, 0.18, 0.24))
	title_row.add_child(title)
	var close := Button.new()
	close.text = "Close"
	close.pressed.connect(_close_letters)
	_style_close(close)
	title_row.add_child(close)

	box.add_child(_file_button("NOTE.LET", "Level 1", false))
	box.add_child(_file_button("DRAFT.LET", "Locked", true))
	box.add_child(_file_button("CARD.LET", "Locked", true))


func _file_button(name: String, detail: String, locked: bool) -> Button:
	var button := Button.new()
	button.text = "%s    %s" % [name, detail]
	button.alignment = HORIZONTAL_ALIGNMENT_LEFT
	button.custom_minimum_size = Vector2(0, 36)
	button.disabled = locked
	button.focus_mode = Control.FOCUS_NONE
	var fill := Color(0.93, 0.94, 0.96) if locked else Color(1, 0.97, 0.93)
	button.add_theme_stylebox_override("normal", _row_style(fill))
	button.add_theme_stylebox_override("hover", _row_style(fill.lightened(0.04)))
	button.add_theme_stylebox_override("pressed", _row_style(fill.darkened(0.06)))
	button.add_theme_stylebox_override("disabled", _row_style(Color(0.92, 0.93, 0.94)))
	button.add_theme_color_override("font_color", Color(0.2, 0.22, 0.28))
	button.add_theme_color_override("font_disabled_color", Color(0.55, 0.57, 0.62))
	button.add_theme_font_size_override("font_size", 13)
	if not locked:
		button.pressed.connect(_open_note)
	return button


func _style_close(button: Button) -> void:
	button.focus_mode = Control.FOCUS_NONE
	button.add_theme_font_size_override("font_size", 12)
	var fill := Color(0.9, 0.91, 0.94)
	button.add_theme_stylebox_override("normal", _row_style(fill))
	button.add_theme_stylebox_override("hover", _row_style(fill.lightened(0.04)))
	button.add_theme_stylebox_override("pressed", _row_style(fill.darkened(0.06)))


func _row_style(fill: Color) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = fill
	style.set_corner_radius_all(10)
	style.content_margin_left = 12
	style.content_margin_right = 12
	style.content_margin_top = 6
	style.content_margin_bottom = 6
	return style


func _draw() -> void:
	var top := Color("8aa4f2")
	var bottom := Color("f3c4b0")
	var bands := 40
	for i in bands:
		var t := float(i) / float(bands - 1)
		draw_rect(Rect2(0, i * 18.0, ROOM_W, 19), top.lerp(bottom, t))
	draw_circle(Vector2(260, 250), 150, Color(1, 1, 1, 0.14))
	draw_circle(Vector2(820, 300), 180, Color(1, 0.86, 0.78, 0.2))


func _chamfer(rect: Rect2, radius: float) -> PackedVector2Array:
	var r := minf(radius, minf(rect.size.x, rect.size.y) * 0.5)
	var x := rect.position.x
	var y := rect.position.y
	var w := rect.size.x
	var h := rect.size.y
	return PackedVector2Array([
		Vector2(x + r, y),
		Vector2(x + w - r, y),
		Vector2(x + w, y + r),
		Vector2(x + w, y + h - r),
		Vector2(x + w - r, y + h),
		Vector2(x + r, y + h),
		Vector2(x, y + h - r),
		Vector2(x, y + r),
	])
