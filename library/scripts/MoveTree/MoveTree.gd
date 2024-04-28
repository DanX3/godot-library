class_name MoveTree extends Node

## MoveTree is a class that manages the different animation states of a character
## it parses all his children looking for a valid node to play
## The next animation played is the name of the next candidate node

@export var player: AnimationPlayer
@export var label_debug: Label

@onready var playingNode = self
var queuedNode : Node = null

func refresh():
	_play_candidate_node()

func _unhandled_input(event):
	if event.is_echo():
		return
	
	if playingNode is MovePressed:
		if event.is_released():
			return
		if event.is_pressed():
			queuedNode = _find_candidate(playingNode)
			if queuedNode != null:
				print("Found queued candidate ", queuedNode.name)
			return
	
	# calling deferred because in the current frame the player may not already
	# have updated all its properties and will be correct the next frame
	if queuedNode == null:
		call_deferred("_play_candidate_node")
	else:
		_play_node(queuedNode)


func _ready():
	player.animation_finished.connect(_on_animation_finished)
	var candidate = _find_candidate(self)
	player.play(candidate.name if candidate != null else "RESET")


func _on_animation_finished(_anim_name: StringName):
	print("finished animation %s" % _anim_name)
	# actually playing next animation node
	if _anim_name == "RESET" and queuedNode != null:
		playingNode = queuedNode
		player.play(queuedNode.name)
		if label_debug != null:
			label_debug.text = playingNode.name
		queuedNode = null
		return
	
	# immediately play queued animation
	if queuedNode != null:
		playingNode = queuedNode
		queuedNode = null
		player.play(playingNode.name)
		if label_debug != null:
			label_debug.text = playingNode.name
		return
	
	_play_candidate_node()


func _play_candidate_node():
	if playingNode == null:
		return
		
	var candidate = _find_candidate(playingNode)
	if candidate != null:
		_play_node(candidate)
		return
		
	_play_node(_find_candidate(self))


func _find_candidate(source: Node) -> Node:
	for child in source.get_children():
		if child.has_method("is_move_valid") and child.is_move_valid():
			return child
	return null


func _play_node(node: Node):
	assert(node != null)
	if player.current_animation == node.name:
		return
	# first play RESET animation to reset properties
	player.play("RESET")
	playingNode = null
	queuedNode = node
	if label_debug != null:
		label_debug.text = "RESET"
