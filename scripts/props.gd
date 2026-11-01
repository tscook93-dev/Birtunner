class_name Props
extends RefCounted

## Shared floor and platform blocks for the desk, the letter, and Motion Bay.


static func add_solid(parent: Node, rect: Rect2, body_color: Color, lip_color: Color, pads: bool) -> void:
	var block := StaticBody2D.new()
	block.position = rect.position
	var body := Polygon2D.new()
	body.color = body_color
	body.polygon = PackedVector2Array([
		Vector2.ZERO,
		Vector2(rect.size.x, 0),
		Vector2(rect.size.x, rect.size.y),
		Vector2(0, rect.size.y),
	])
	block.add_child(body)
	var lip := Polygon2D.new()
	lip.color = lip_color
	var lip_h := 5.0 if pads else 4.0
	lip.polygon = PackedVector2Array([
		Vector2.ZERO,
		Vector2(rect.size.x, 0),
		Vector2(rect.size.x, lip_h),
		Vector2(0, lip_h),
	])
	block.add_child(lip)
	if pads:
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
	parent.add_child(block)


static func add_wall(parent: Node, rect: Rect2) -> void:
	var wall := StaticBody2D.new()
	var shape := RectangleShape2D.new()
	shape.size = rect.size
	var collision := CollisionShape2D.new()
	collision.shape = shape
	collision.position = rect.position + rect.size * 0.5
	wall.add_child(collision)
	parent.add_child(wall)
