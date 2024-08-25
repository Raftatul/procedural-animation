extends Area3D


signal score


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node3D) -> void:
	if body.has_meta("is_ball"):
		score.emit()
		GlobalCanvasLayer.add_point(1)
		body.queue_free()
