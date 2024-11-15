extends Node2D

var counter := 0
@export var res: CustomResource
@export var resources: Array[CustomResource]


func _ready() -> void:
	$CanvasLayer/GridContainer/ResName.text = res.resName
	get_node("/root/Singleton").set_state()


func _on_increment_pressed() -> void:
	counter += 1
	$CanvasLayer/GridContainer/Counter.text = str(counter)


func _on_rand_color_pressed() -> void:
	$CanvasLayer/GridContainer/Color.modulate = Color(randf(), randf(), randf())


func _on_res_switch_pressed() -> void:
	if res.resName == "Pappa":
		res = resources[1]
	else:
		res = resources[0]
	$CanvasLayer/GridContainer/ResName.text = res.resName


func _on_save_pressed() -> void:
	get_node("/root/Singleton").save_game()


func _on_load_pressed() -> void:
	get_node("/root/Singleton").load_game()
	get_tree().change_scene_to_file("res://library/demo/SaveLoad/GameScene.tscn")


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://library/demo/SaveLoad/MainMenu.tscn")


func load_state(state: SaveState) -> void:
	counter = state.counter
	res = state.res
	$CanvasLayer/GridContainer/ResName.text = res.resName
	$CanvasLayer/GridContainer/Counter.text = str(counter)


func save_state(state: SaveState) -> void:
	state.counter = counter
	state.res = res
