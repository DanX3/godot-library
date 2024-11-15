extends TextureRect


func load_state(state: SaveState) -> void:
	modulate = state.color


func save_state(state: SaveState) -> void:
	state.color = modulate
