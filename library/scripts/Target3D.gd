extends Node3D

@onready var arrow := $CanvasLayer/ArrowOrigin
@onready var point := $CanvasLayer/Point

@export var sourceNode: Node3D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var camera := get_viewport().get_camera_3d()
	var cameraDir = -camera.global_basis.z
	var targetDir = -camera.global_transform.looking_at(global_position).basis.z
	targetDir.y = 0
	cameraDir.y = 0
	arrow.rotation = targetDir.signed_angle_to(cameraDir, Vector3.UP)

	point.position = camera.unproject_position(global_position)
	

func _on_visible_on_screen_notifier_3d_screen_entered() -> void:
	arrow.hide()
	point.show()


func _on_visible_on_screen_notifier_3d_screen_exited() -> void:
	arrow.show()
	point.hide()


func _on_visibility_changed() -> void:
	var is_visible = get_viewport().get_camera_3d().is_position_in_frustum(global_position)
	point.visible = is_visible
	arrow.visible = not is_visible
	$CollisionShape3D.disabled = not visible
