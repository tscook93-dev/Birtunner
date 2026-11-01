extends CharacterBody2D

const SPEED := 210.0
const ACCEL := 2400.0
const JUMP_SPEED := -680.0
const JUMP_CUT := 0.65
const GRAVITY := 1800.0
const COYOTE_TIME := 0.12
const JUMP_BUFFER := 0.12

var coyote := 0.0
var jump_buffer := 0.0
var jump_was_down := false
var facing := 1
var run_time := 0.0

@onready var sprite: Sprite2D = $Sprite


func _physics_process(delta: float) -> void:
	var grounded := is_on_floor()
	if not grounded:
		velocity.y += GRAVITY * delta

	# Coyote time keeps a jump available for a moment after walking off a ledge.
	if grounded:
		coyote = COYOTE_TIME
	else:
		coyote = maxf(coyote - delta, 0.0)

	# Jump buffer remembers a press that landed a little early.
	var jump_down := Input.is_action_pressed("jump")
	if jump_down and not jump_was_down:
		jump_buffer = JUMP_BUFFER
	else:
		jump_buffer = maxf(jump_buffer - delta, 0.0)
	if jump_was_down and not jump_down and velocity.y < 0.0:
		velocity.y *= JUMP_CUT
	jump_was_down = jump_down

	if jump_buffer > 0.0 and coyote > 0.0:
		velocity.y = JUMP_SPEED
		jump_buffer = 0.0
		coyote = 0.0

	var axis := Input.get_axis("move_left", "move_right")
	velocity.x = move_toward(velocity.x, axis * SPEED, ACCEL * delta)
	if axis != 0.0:
		facing = -1 if axis < 0.0 else 1

	move_and_slide()
	_animate(axis, delta)


func _animate(axis: float, delta: float) -> void:
	sprite.flip_h = facing < 0
	if not is_on_floor():
		sprite.frame = 5
		run_time = 0.0
		return
	if axis != 0.0:
		run_time += delta
		sprite.frame = 1 + (int(run_time * 12.0) % 4)
		return
	run_time = 0.0
	sprite.frame = 0
