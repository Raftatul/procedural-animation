extends Node


const CUBE = preload("res://scenes/cube.tscn")

@onready var spawnpoint: Marker3D = $Spawnpoint


func _on_timer_timeout() -> void:
	var ball := CUBE.instantiate()
	ball.top_level = true
	spawnpoint.add_child(ball)
	ball.global_position = spawnpoint.global_position
