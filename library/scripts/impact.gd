class_name ImpactEffect extends CanvasLayer

@onready var texture = $Impact
@onready var player = $AnimationPlayer

func impact(world_pos: Vector2) -> void:
	if player.is_playing():
		player.stop()
	var p = world_pos * get_viewport().canvas_transform.affine_inverse()
	var viewport_coords = p / texture.get_viewport_rect().size
	texture.material.set_shader_parameter("impact_position", viewport_coords)
	player.play("impact")
