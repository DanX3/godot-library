extends StaticBody2D

@export var baloon: Sprite2D

func on_player_face(player: Node2D):
	baloon.show()
	player.modulate = Color.ORANGE

func on_player_leave(player: Node2D):
	baloon.hide()
	player.modulate = Color.WHITE
	
