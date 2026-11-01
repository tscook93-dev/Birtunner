extends Node

## Binds keyboard controls before the test room reads them.
## Arrows move and jump; Space also jumps. Touch buttons use the same actions.

func _enter_tree() -> void:
	_bind("move_left", KEY_LEFT)
	_bind("move_right", KEY_RIGHT)
	_bind("jump", KEY_SPACE)
	_bind("jump", KEY_UP)


func _bind(action: StringName, key: Key) -> void:
	if not InputMap.has_action(action):
		InputMap.add_action(action)
	for event in InputMap.action_get_events(action):
		if event is InputEventKey and event.physical_keycode == key:
			return
	var ev := InputEventKey.new()
	ev.physical_keycode = key
	InputMap.action_add_event(action, ev)
