extends TileMap
## Spawn the scene on the coordinates of the placed tile at coords
## located on the specified layer
## this will erase the original tile

class_name SpawnNodes

@export var layerName: String
@export var spawns: Array[PairCoordsScene]

func _ready():
	_spawn_tiles()

func _get_coords_scene(coords: Vector2i):
	for spawn in spawns:
		if spawn.coords == coords:
			return spawn
	return null

## Returns the index of the requested layer name
## returns -1 if the layer provided does not exists
func _get_layer_index(layerName: String) -> int:
	for i in range(get_layers_count()):
		if get_layer_name(i) == layerName:
			return i
	return -1

func _spawn_tiles():
	# get the layer name, return if it does not exists
	var layer = _get_layer_index(layerName)
	if layer < 0:
		push_error("Layer " + layerName + " does not exists")
		return
	
	
	for coord in get_used_cells(layer):
		var spawn = _get_coords_scene(get_cell_atlas_coords(layer, coord))
		if spawn == null:
			continue
		
		var new_spawnable = spawn.scene.instantiate()
		add_child(new_spawnable)
		new_spawnable.position = map_to_local(coord)
		erase_cell(layer, coord)
