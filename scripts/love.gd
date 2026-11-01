extends CharacterBody2D

const GRAVITY := 1800.0

var spawns_copies := false
var speed := 96.0
var wander := -1
var _spawn_wait := 5.0

@onready var sprite: Sprite2D = $Sprite


func _ready() -> void:
	if not spawns_copies:
		speed = 62.0
		sprite.modulate = Color(1, 0.72, 0.76)
		add_to_group("love_copy")
	$Hit.body_entered.connect(_touch)


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	var player := get_tree().get_first_node_in_group("player") as Node2D
	if player != null and abs(player.global_position.y - global_position.y) < 72.0:
		var dx := player.global_position.x - global_position.x
		if abs(dx) > 6.0:
			wander = -1 if dx < 0.0 else 1
	velocity.x = float(wander) * speed
	move_and_slide()
	if is_on_wall():
		wander *= -1
	sprite.flip_h = wander > 0
	if not spawns_copies:
		return
	_spawn_wait -= delta
	if _spawn_wait <= 0.0:
		_spawn_wait = 5.0
		_spawn()


func _spawn() -> void:
	if get_tree().get_nodes_in_group("love_copy").size() >= 2:
		return
	var copy := preload("res://scenes/love.tscn").instantiate() as CharacterBody2D
	copy.set("spawns_copies", false)
	copy.position = position + Vector2(-28, 0)
	get_parent().add_child(copy)


func _touch(body: Node) -> void:
	if not body.is_in_group("player"):
		return
	var stage := get_tree().get_first_node_in_group("letter")
	if stage != null and stage.has_method("caught"):
		stage.caught()
