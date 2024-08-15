extends Node


#func _ready() -> void:
	#Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _input(event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_P):
		get_tree().quit()
