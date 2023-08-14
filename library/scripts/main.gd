extends Node2D

@export var persistent_test: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if Input.is_action_just_pressed("ui_accept"):
		var new_instance = persistent_test.instantiate()
		add_child(new_instance)
		new_instance.global_position = get_global_mouse_position()

func _on_save_pressed():
	($SaveLoad as SaveLoad).save_game()


func _on_load_pressed():
	for persist in get_tree().get_nodes_in_group("persist"):
		persist.queue_free()
	($SaveLoad as SaveLoad).load_game()
