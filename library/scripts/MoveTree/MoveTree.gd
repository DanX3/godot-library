class_name MoveTree extends Node

signal play_anim(anim_name: String)

@export var player: AnimationPlayer
@export var label_debug: Label

@onready var playingNode = self
var isPlaying = false
var candidate = null

func _unhandled_input(event):
	_find_candidate()
	if not isPlaying and candidate != null:
		_play_candidate()

func _ready():
	player.animation_finished.connect(_on_animation_finished)
	_find_candidate(true)


func _on_animation_finished(_anim_name: StringName):
	print("animation finished")
	var old_candidate = candidate
	# check candidate before playing next
	# keep new candidate if != null
	_find_candidate()
	if candidate == null:
		candidate = old_candidate
	
	if candidate != null:
		_play_candidate()
	else:
		isPlaying = false
		playingNode = self
	if label_debug != null:
		label_debug.text = playingNode.name


func _find_candidate(autoplay: bool = false) -> bool:
	for child in playingNode.get_children():
		if child.has_method("is_move_valid") and child.is_move_valid():
			candidate = child
			if autoplay:
				_play_candidate()
			return true
	return false


func _play_candidate():
	assert(candidate != null)
	playingNode = candidate
	emit_signal("play_anim", playingNode.name)
	if label_debug != null:
		label_debug.text = candidate.name
	candidate = null
	isPlaying = true
