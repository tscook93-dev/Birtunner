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
	_build_block(FLOOR, true)
	for rect in PLATFORMS:
		_build_block(rect, false)
	_add_wall(Rect2(-28, -120, 28, ROOM_H + 240))
	_add_wall(Rect2(ROOM_W, -120, 28, ROOM_H + 240))


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


func _build_block(rect: Rect2, is_floor: bool) -> void:
	var block := StaticBody2D.new()
	block.position = rect.position
	var body := Polygon2D.new()
	body.color = Color("16303a") if is_floor else Color("1c5564")
	body.polygon = PackedVector2Array([
		Vector2.ZERO,
		Vector2(rect.size.x, 0),
		Vector2(rect.size.x, rect.size.y),
		Vector2(0, rect.size.y),
	])
	block.add_child(body)
	var lip := Polygon2D.new()
	lip.color = Color("f0a04a") if is_floor else Color("67ffd6")
	var lip_h := 5.0 if is_floor else 4.0
	lip.polygon = PackedVector2Array([
		Vector2.ZERO,
		Vector2(rect.size.x, 0),
		Vector2(rect.size.x, lip_h),
		Vector2(0, lip_h),
	])
	block.add_child(lip)
	if is_floor:
		var x := 18.0
		while x < rect.size.x - 10.0:
			var dot := Polygon2D.new()
			dot.color = Color("e39a45")
			dot.polygon = PackedVector2Array([
				Vector2(x, 16),
				Vector2(x + 6, 16),
				Vector2(x + 6, 22),
				Vector2(x, 22),
			])
			block.add_child(dot)
			x += 52.0
	var shape := RectangleShape2D.new()
	shape.size = rect.size
	var collision := CollisionShape2D.new()
	collision.shape = shape
	collision.position = rect.size * 0.5
	block.add_child(collision)
	add_child(block)


func _add_wall(rect: Rect2) -> void:
	var wall := StaticBody2D.new()
	var shape := RectangleShape2D.new()
	shape.size = rect.size
	var collision := CollisionShape2D.new()
	collision.shape = shape
	collision.position = rect.position + rect.size * 0.5
	wall.add_child(collision)
	add_child(wall)
