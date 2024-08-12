extends CanvasLayer


func _on_game_controller_control_stat_changed(value: bool) -> void:
	visible = value
