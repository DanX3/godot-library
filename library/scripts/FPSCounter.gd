class_name FPSCounter extends Label


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	text = "FPS: %4d\nFrametime: %.2f ms\n" % [1.0 / delta, delta * 1000.0]
