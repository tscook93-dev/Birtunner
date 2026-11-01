extends Node2D

const ROOM_W := 1600.0
const ROOM_H := 480.0
const FLOOR := Rect2(0, 400, 1600, 80)

const PLATFORMS: Array[Rect2] = [
	Rect2(150, 346, 160, 18),
	Rect2(400, 292, 160, 18),
	Rect2(700, 214, 130, 18),
	Rect2(920, 328, 180, 18),
	Rect2(1180, 250, 140, 18),
	Rect2(1400, 188, 160, 18),
]


func _ready() -> void:
	var camera := $Player/Camera as Camera2D
	camera.limit_left = 0
	camera.limit_top = 0
	camera.limit_right = int(ROOM_W)
	camera.limit_bottom = int(ROOM_H)
	Props.add_solid(self, FLOOR, Color("16303a"), Color("f0a04a"), true)
	for rect in PLATFORMS:
		Props.add_solid(self, rect, Color("1c5564"), Color("67ffd6"), false)
	Props.add_wall(self, Rect2(-28, -120, 28, ROOM_H + 240))
	Props.add_wall(self, Rect2(ROOM_W, -120, 28, ROOM_H + 240))


func _draw() -> void:
	draw_rect(Rect2(0, 0, ROOM_W, ROOM_H), Color("12151f"))
	var trace := Color(0.16, 0.45, 0.42, 0.28)
	for y in range(36, int(FLOOR.position.y), 40):
		draw_line(Vector2(0, y), Vector2(ROOM_W, y), trace, 1.0)
	var faint := Color(0.16, 0.45, 0.42, 0.1)
	for x in range(24, int(ROOM_W), 80):
		draw_line(Vector2(x, 16), Vector2(x, FLOOR.position.y), faint, 1.0)
	var chip := Color("1a3040")
	var chip_top := Color("2f8f80")
	var pin := Color("8aa4b4")
	for box in [Rect2(48, 52, 84, 32), Rect2(520, 70, 100, 28), Rect2(980, 48, 72, 36), Rect2(1240, 78, 110, 30)]:
		draw_rect(box, chip)
		draw_rect(Rect2(box.position, Vector2(box.size.x, 4)), chip_top)
		var pins := int(box.size.x / 10.0)
		for i in pins:
			draw_rect(Rect2(box.position.x + 4.0 + float(i) * 10.0, box.position.y + box.size.y, 3, 5), pin)


