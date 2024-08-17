extends Node


const BALL = preload("res://scenes/ball.tscn")

@onready var spawnpoints: Node3D = $Spawnpoints


func _on_timer_timeout() -> void:
	var amount := randi_range(1, 5)
	var points := spawnpoints.get_children()
	
	var final_points := []
	
	for i in range(amount):
		var point = points.pick_random()
		
		points.erase(point)
		final_points.append(point)
	
	for i in final_points:
		var ball := BALL.instantiate()
		add_child(ball)
		ball.global_position = i.global_position
