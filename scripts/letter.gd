extends Node2D

const ROOM_W := 1320.0
const ROOM_H := 480.0
const FLOOR := Rect2(0, 400, 1320, 80)
const PLAYER_START := Vector2(280, 376)
const VIRUS_START := Vector2(720, 384)

const PLATFORMS: Array[Rect2] = [
	Rect2(420, 336, 160, 16),
	Rect2(660, 276, 150, 16),
	Rect2(880, 336, 160, 16),
	Rect2(1100, 270, 160, 16),
]

var done := false
var safe := 0.6
var virus: CharacterBody2D
var exit_area: Area2D

@onready var player: CharacterBody2D = $Player
@onready var hint: Label = $Hud/Hint


func _ready() -> void:
	add_to_group("letter")
	var camera := $Player/Camera as Camera2D
	camera.limit_left = 0
	camera.limit_top = 0
	camera.limit_right = int(ROOM_W)
	camera.limit_bottom = int(ROOM_H)
	Props.add_solid(self, FLOOR, Color("3a2430"), Color("e7c9a4"), false)
	for rect in PLATFORMS:
		Props.add_solid(self, rect, Color("5c4038"), Color("f3e2c4"), false)
	Props.add_wall(self, Rect2(-28, -80, 28, ROOM_H + 160))
	Props.add_wall(self, Rect2(ROOM_W, -80, 28, ROOM_H + 160))
	virus = preload("res://scenes/love.tscn").instantiate()
	virus.spawns_copies = true
	virus.position = VIRUS_START
	add_child(virus)
	exit_area = Area2D.new()
	exit_area.collision_layer = 0
	exit_area.collision_mask = 2
	var shape := RectangleShape2D.new()
	shape.size = Vector2(170, 180)
	var collision := CollisionShape2D.new()
	collision.shape = shape
	collision.position = Vector2(1235, 320)
	exit_area.add_child(collision)
	add_child(exit_area)
	player.position = PLAYER_START


func _physics_process(delta: float) -> void:
	if safe > 0.0:
		safe -= delta
	if done or safe > 0.0:
		return
	if exit_area.overlaps_body(player):
		done = true
		hint.text = "Letter survived"
		get_tree().create_timer(1.3).timeout.connect(_return_to_desk)


func caught() -> void:
	if done or safe > 0.0:
		return
	safe = 1.2
	player.global_position = PLAYER_START
	player.velocity = Vector2.ZERO
	hint.text = "Caught"
	for copy in get_tree().get_nodes_in_group("love_copy"):
		copy.queue_free()
	if is_instance_valid(virus):
		virus.position = VIRUS_START
		virus.velocity = Vector2.ZERO
	get_tree().create_timer(0.9).timeout.connect(_hint_back)


func _hint_back() -> void:
	if done or not is_inside_tree():
		return
	hint.text = "ILOVEYOU walks the floor"


func _return_to_desk() -> void:
	if not is_inside_tree():
		return
	get_tree().change_scene_to_file("res://scenes/desktop.tscn")


func _draw() -> void:
	draw_rect(Rect2(0, 0, ROOM_W, ROOM_H), Color("241820"))
	var rule := Color(0.93, 0.84, 0.7, 0.16)
	for y in range(56, 390, 28):
		draw_line(Vector2(24, y), Vector2(ROOM_W - 24, y), rule, 1.0)
	draw_line(Vector2(56, 36), Vector2(56, 390), Color(0.75, 0.28, 0.32, 0.45), 2.0)
	draw_circle(Vector2(1235, 292), 18, Color("a12836"))
	draw_circle(Vector2(1235, 292), 8, Color("f0d2a4"))
