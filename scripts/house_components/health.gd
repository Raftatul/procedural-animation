extends Area3D


signal die

var alive := true


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node3D) -> void:
	if !alive:
		return
	
	alive = false
	die.emit()
