extends MarginContainer

@onready var player_marker = $NinePatchRect/PlayerMarker
@onready var marker_default = $NinePatchRect/MarkerDefault
@onready var marker_parent = $NinePatchRect

## Marker pairs to tell which icons to give to which nodes group
@export var marker_icons: Array[MinimapMarker]

## The amount of margin to clamp the icons depending on the border of the provided minimap
@export var map_margin := Vector2.ZERO

## How much the icons scale when far away from the viewport:
## 1 hides the icons as they exit the viewport
## and higher values will scale the icons slower as they get far away
@export var vision_offviewport = 1.0

## The player, base to compute the distance from the other nodes. 
## To set before the process of the minimap
@export var player: Node2D = null

## The markers are created in the _ready of the minimap. 
## Then the minimap monitors these nodes for new children.
## If a new child matches the provided setup, it will be added its corresponding marker
@export var monitoring_parents: Array[Node]
var grid_scale = 0.1

## Dictionary<NodePath, Marker>
var markers = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	vision_offviewport = max(1.0, vision_offviewport)
	player_marker.position = 0.5 * $NinePatchRect.size - 0.5 * player_marker.size
	for pair in marker_icons:
		for node in get_tree().get_nodes_in_group(pair.group):
			if node is Node2D:
				_add_marker(node, pair)
	
	# monitor the tree for every new node that is added
	# to add its relative marker in the minimap
	for node in monitoring_parents:
		node.child_entered_tree.connect(_on_child_entered_tree)

func _add_marker(node: Node2D, pair: MinimapMarker):
	var marker = marker_default.duplicate() as TextureRect
	marker.texture = pair.icon
	marker.size = pair.icon.get_size()
	marker.pivot_offset = 0.5 * pair.icon.get_size()
	marker_parent.add_child(marker)
	marker.show()
	markers[node.get_path()] = marker
	var path = node.get_path()
	node.tree_exiting.connect(_remove_marker.bind(node.get_path()))

func _on_child_entered_tree(node: Node):
	for pair in marker_icons:
		if node.get_groups().has(pair.group):
			_add_marker(node, pair)
			break

func _remove_marker(nodepath):
	markers[nodepath].queue_free()
	markers.erase(nodepath)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if player == null:
		print_debug("Player is null on minimap, set it before _process")
		return
	
	var markers_to_erase = []
	for nodepath in markers:
		# erase the marker if the node does not exists anymore
		if !has_node(nodepath):
			markers_to_erase.append(nodepath)
			continue
	
		# update the position of the marker
		var tex_size = markers[nodepath].texture.get_size()
		var marker_pos = player_marker.position \
			+ 0.5 * player_marker.texture.get_size() \
			+ grid_scale * (get_node(nodepath).global_position - player.global_position)
		marker_pos -= 0.5 * tex_size
		var size = marker_parent
		var marker_pos_clamped = Vector2.ZERO
		marker_pos_clamped.x = clamp(marker_pos.x, map_margin.x, marker_parent.size.x - map_margin.x - tex_size.x)
		marker_pos_clamped.y = clamp(marker_pos.y, map_margin.y, marker_parent.size.y - map_margin.y - tex_size.y)
		markers[nodepath].position = marker_pos_clamped
		
		# scale down the icon the more they are far away from the viewport
		var distance = marker_pos.distance_to(marker_pos_clamped)
		markers[nodepath].scale = Vector2.ONE * clamp(1.0 - (1.0 / vision_offviewport) * distance, 0.0, 1.0)
		

	for nodepath_to_erase in markers_to_erase:
		markers[nodepath_to_erase].queue_free()
		markers.erase(nodepath_to_erase)

