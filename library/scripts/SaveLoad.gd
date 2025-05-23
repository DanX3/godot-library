class_name SaveLoad extends Node

## To save the state of a node you need to:
## 1 - add the node to the group "persist"
## 2 - make is as a separate scene, in order to be able to instance it and free it
## 3 - add a function save() returning a dictionary with all the properties you want to serialize
##     the scene name, parent and position are automatically serialized


# Note: This can be called from anywhere inside the tree. This function is
# path independent.
# Go through everything in the persist category and ask them to return a
# dict of relevant variables.
func save_game():
	var save_file = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("persist")
	for node in save_nodes:
		# Check the node is an instanced scene so it can be instanced again during load.
		if node.scene_file_path.is_empty():
			print("persistent node '%s' is not an instanced scene, skipped" % node.name)
			continue

		# Check the node has a save function.
		if !node.has_method("save"):
			print("persistent node '%s' is missing a save() function, skipped" % node.name)
			continue

		# Call the node's save function.
		var node_data = node.call("save")

		# add mandatory fields
		node_data["__filename__"] = node.get_scene_file_path()
		node_data["__parent__"] = node.get_parent().get_path()
		if node is Node2D:
			node_data["__pos_x__"] = node.position.x
			node_data["__pos_y__"] = node.position.y

		# JSON provides a static method to serialized JSON string.
		var json_string = JSON.stringify(node_data)

		# Store the save dictionary as a new line in the save file.
		save_file.store_line(json_string)


# Note: This can be called from anywhere inside the tree. This function
# is path independent.
func load_game():
	if not FileAccess.file_exists("user://savegame.save"):
		return  # Error! We don't have a save to load.

	# We need to revert the game state so we're not cloning objects
	# during loading. This will vary wildly depending on the needs of a
	# project, so take care with this step.
	# For our example, we will accomplish this by deleting saveable objects.
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for i in save_nodes:
		i.queue_free()

	# Load the file line by line and process that dictionary to restore
	# the object it represents.
	var save_file = FileAccess.open("user://savegame.save", FileAccess.READ)
	while save_file.get_position() < save_file.get_length():
		var json_string = save_file.get_line()

		# Creates the helper class to interact with JSON
		var json = JSON.new()

		# Check if there is any error while parsing the JSON string, skip in case of failure
		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			print(
				"JSON Parse Error: ",
				json.get_error_message(),
				" in ",
				json_string,
				" at line ",
				json.get_error_line()
			)
			continue

		# Get the data from the JSON object
		var node_data = json.get_data()

		# Firstly, we need to create the object and add it to the tree and set its position.
#		if not _has_valid_keys(node_data):
#			continue

		var new_object = load(node_data["__filename__"]).instantiate()
		get_node(node_data["__parent__"]).add_child(new_object)
		if new_object is Node2D:
			new_object.position = Vector2(node_data["__pos_x__"], node_data["__pos_y__"])

		# Now we set the remaining variables.
		for i in node_data.keys():
			if i == "__filename__" or i == "__parent__" or i == "__pos_x__" or i == "__pos_y__":
				continue
			new_object.set(i, node_data[i])


func _has_valid_keys(node_data: Dictionary) -> bool:
	for key in ["filename", "parent", "pos_x", "pos_y"]:
		if not node_data.has(key):
			print("Node data does not have key ", key)
			return false
	return true
