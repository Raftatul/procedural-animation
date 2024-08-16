extends Node


var points := 0

@onready var label: Label = $MarginContainer/Control/HBoxContainer/Label


func add_point(value: int) -> void:
	points += value
	label.text = str(points)
