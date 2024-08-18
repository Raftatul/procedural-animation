extends Node


func _ready() -> void:
	InputMap.add_action("switch_mouse")
	var event_o := InputEventKey.new()
	event_o.physical_keycode = KEY_O
	InputMap.action_add_event("switch_mouse", event_o)


func _input(event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_P):
		get_tree().quit()
	if event.is_action_pressed("switch_mouse"):
		match Input.mouse_mode:
			Input.MOUSE_MODE_CAPTURED:
				Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			Input.MOUSE_MODE_VISIBLE:
				Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
				
