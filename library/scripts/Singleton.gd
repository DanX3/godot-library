extends Node

# State to load once the game scene has been loaded
# The idea is to populate this field before changing to the game scene
# then set the game state once the game scene has been loaded by calling
# The main game node should consume this state with `set_state`
var stateToLoad: SaveState = null

const SavePath = "user://savegame.tres"


# Loops over all the nodes in the group "SaveLoad"
# populating the state by calling `save_state` on each node
# then saving it to disk
func save_game() -> void:
	var state := SaveState.new()
	for child in get_tree().get_nodes_in_group("SaveLoad"):
		child.save_state(state)
	var error = ResourceSaver.save(state, SavePath)
	if error:
		printerr("Error saving game to disk: ", error)
	else:
		print("Game saved successfully @ ", ProjectSettings.globalize_path(SavePath))


# Populate the stateToLoad with the state loaded from disk, if any
# The main game logic should set the state when ready
func load_game() -> void:
	if not ResourceLoader.exists(SavePath):
		return
	var state = ResourceLoader.load(SavePath, "SaveState")
	if state:
		stateToLoad = state


# Once the main game node is ready, this method calls on each node in the "SaveLoad" group
# with the stateToLoad. Each node should take its own data to restore its state
func set_state() -> void:
	if !stateToLoad:
		return
	for child in get_tree().get_nodes_in_group("SaveLoad"):
		child.load_state(stateToLoad)
	stateToLoad = null
