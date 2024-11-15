extends Node2D


func _on_button_pressed() -> void:
	get_node("/root/Singleton").load_game()
	get_tree().change_scene_to_file("res://library/demo/SaveLoad/GameScene.tscn")
