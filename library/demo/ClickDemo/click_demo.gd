extends Node2D

var explosion = preload("res://library/assets/Particles/Explosion.tscn")

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		Utils.spawn_child(self, explosion, get_global_mouse_position())
