extends CanvasLayer

## On-screen Left, Right, and Jump. Handles real touches and mouse clicks,
## because TouchScreenButton ignores the mouse unless touch emulation is on.

const BUTTON := 96.0
const MARGIN := 12.0
const GAP := 12.0

const ACTIONS := ["move_left", "move_right", "jump"]

var rects := {
	"move_left": Rect2(),
	"move_right": Rect2(),
	"jump": Rect2(),
}
var pointers := {}
var mouse_down := false

@onready var left_sprite: Sprite2D = $Left
@onready var right_sprite: Sprite2D = $Right
@onready var jump_sprite: Sprite2D = $Jump

var normal := {}
var pressed := {}


func _ready() -> void:
	Input.action_release("move_left")
	Input.action_release("move_right")
	Input.action_release("jump")
	normal = {
		"move_left": left_sprite.texture,
		"move_right": right_sprite.texture,
		"jump": jump_sprite.texture,
	}
	pressed = {
		"move_left": preload("res://art/btn_left_down.png"),
		"move_right": preload("res://art/btn_right_down.png"),
		"jump": preload("res://art/btn_jump_down.png"),
	}
	get_viewport().size_changed.connect(_layout)
	_layout()


func _layout() -> void:
	var size := get_viewport().get_visible_rect().size
	var y := size.y - MARGIN - BUTTON
	var spots := {
		"move_left": Vector2(MARGIN, y),
		"move_right": Vector2(MARGIN + BUTTON + GAP, y),
		"jump": Vector2(size.x - MARGIN - BUTTON, y),
	}
	var sprites := {
		"move_left": left_sprite,
		"move_right": right_sprite,
		"jump": jump_sprite,
	}
	for action in ACTIONS:
		sprites[action].position = spots[action]
		rects[action] = Rect2(spots[action], Vector2(BUTTON, BUTTON))


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		mouse_down = event.pressed
		_pointer(-1, event.position, event.pressed)
	elif event is InputEventMouseMotion and mouse_down:
		_pointer(-1, event.position, true)
	elif event is InputEventScreenTouch:
		_pointer(event.index, event.position, event.pressed)
	elif event is InputEventScreenDrag:
		_pointer(event.index, event.position, true)


func _pointer(id: int, pos: Vector2, down: bool) -> void:
	var action := _hit(pos) if down else ""
	var previous: String = pointers.get(id, "")
	if previous == action:
		return
	if previous != "":
		pointers.erase(id)
		if not _held(previous):
			Input.action_release(previous)
	if action != "":
		pointers[id] = action
		Input.action_press(action)
	_refresh_icons()


func _hit(pos: Vector2) -> String:
	# Jump sits under the right thumb, so it wins if a finger covers both.
	if rects["jump"].has_point(pos):
		return "jump"
	if rects["move_right"].has_point(pos):
		return "move_right"
	if rects["move_left"].has_point(pos):
		return "move_left"
	return ""


func _held(action: String) -> bool:
	for held in pointers.values():
		if held == action:
			return true
	return false


func _refresh_icons() -> void:
	var sprites := {
		"move_left": left_sprite,
		"move_right": right_sprite,
		"jump": jump_sprite,
	}
	for action in ACTIONS:
		sprites[action].texture = pressed[action] if _held(action) else normal[action]
