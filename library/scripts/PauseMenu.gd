extends Control


func _ready():
	hide()

func _input(event):
	if Input.is_action_just_pressed("pause"):
		_set_paused(!get_tree().paused)

func _set_paused(paused: bool):
	get_tree().paused = paused
	if paused:
		show()
	else:
		hide()


func _on_cursor_selected(node_name):
	if node_name == "Continue":
		_set_paused(false)
	if node_name == "Quit":
		get_tree().quit()
