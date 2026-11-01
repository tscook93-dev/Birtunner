extends Node2D

const ROOM_W := 1400.0
const ROOM_H := 480.0
const FLOOR := Rect2(0, 400, 1400, 80)

var _enter := 0.0
var _leaving := false

@onready var hint: Label = $Hud/Hint
@onready var door: Area2D = $Letter
@onready var player: CharacterBody2D = $Player


func _ready() -> void:
	var camera := $Player/Camera as Camera2D
	camera.limit_left = 0
	camera.limit_top = 0
	camera.limit_right = int(ROOM_W)
	camera.limit_bottom = int(ROOM_H)
	Props.add_solid(self, FLOOR, Color("1a2330"), Color("d7b07a"), false)
	Props.add_wall(self, Rect2(-28, -80, 28, ROOM_H + 160))
	Props.add_wall(self, Rect2(ROOM_W, -80, 28, ROOM_H + 160))


func _physics_process(delta: float) -> void:
	if _leaving:
		return
	if door.overlaps_body(player):
		_enter += delta
		hint.text = "Entering the letter"
		if _enter > 0.28:
			_leaving = true
			get_tree().change_scene_to_file.call_deferred("res://scenes/letter.tscn")
	else:
		_enter = 0.0
		hint.text = "Run into the letter"


func _draw() -> void:
	draw_rect(Rect2(0, 0, ROOM_W, ROOM_H), Color("1a2433"))
	draw_rect(Rect2(18, 200, ROOM_W - 36, 192), Color("243246"))
	var dot := Color(1, 1, 1, 0.05)
	for y in range(220, 380, 32):
		for x in range(40, int(ROOM_W) - 30, 40):
			draw_rect(Rect2(x, y, 2, 2), dot)
	for spot in [Vector2(90, 236), Vector2(160, 258), Vector2(1180, 240), Vector2(1260, 262)]:
		_glyph(spot)


func _glyph(at: Vector2) -> void:
	draw_rect(Rect2(at, Vector2(26, 32)), Color("e6d3ae"))
	draw_rect(Rect2(at.x, at.y, 26, 2), Color("5a4030"))
	draw_rect(Rect2(at.x, at.y + 30, 26, 2), Color("5a4030"))
	draw_rect(Rect2(at.x + 4, at.y + 8, 18, 2), Color("b08958"))
	draw_rect(Rect2(at.x + 4, at.y + 14, 12, 2), Color("b08958"))
